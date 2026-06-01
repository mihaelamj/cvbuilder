import CVBuilder
import CVBuilderCLI
import Foundation
import Testing

@Suite("CVBuilderCLI")
struct CVBuilderCLITests {
    @Test("parser accepts required paths, format, and check mode")
    func parserAcceptsOptions() throws {
        let options = try CVBuilderCLI.Options.parse([
            "--data",
            "cv.json",
            "--out=cv/index.md",
            "--format",
            "json",
            "--check"
        ])

        let expected = try CVBuilderCLI.Options(
            dataPath: "cv.json",
            outputPath: "cv/index.md",
            format: .json,
            check: true
        )

        #expect(options == expected)
    }

    @Test("parser rejects missing arguments and unknown formats")
    func parserRejectsInvalidArguments() throws {
        try expectFailure(CVBuilderCLI.Options.parse([])) { failure in
            #expect(failure == .missingRequiredOption("--data <path>"))
        }
        try expectFailure(CVBuilderCLI.Options.parse(["--data", "cv.json"])) { failure in
            #expect(failure == .missingRequiredOption("--out <path>"))
        }
        try expectFailure(CVBuilderCLI.Options.parse(["--data", "--out", "cv.md"])) { failure in
            #expect(failure == .missingValue(option: "--data"))
        }
        let unknownFormatArguments = ["--data", "cv.json", "--out", "cv.md", "--format", "html"]
        try expectFailure(CVBuilderCLI.Options.parse(unknownFormatArguments)) { failure in
            #expect(failure == .unknownFormat("html"))
            #expect(failure.message.contains("markdown, json"))
        }
        try expectFailure(CVBuilderCLI.Options.parse(["cv.json"])) { failure in
            #expect(failure == .unexpectedArgument("cv.json"))
        }
    }

    @Test("runner renders Markdown from CVDocument JSON")
    func runnerWritesMarkdown() throws {
        let tempDirectory = try TemporaryDirectory()
        defer { tempDirectory.cleanup() }

        let inputURL = try tempDirectory.write("cv.json", contents: cliFixtureJSON)
        let outputURL = tempDirectory.url.appendingPathComponent("cv/index.md")

        try makeRunner().run(.init(dataPath: inputURL.path, outputPath: outputURL.path))

        let output = try String(contentsOf: outputURL, encoding: .utf8)
        #expect(output.contains("""
        # Alex Example
        CLI-focused Swift Engineer
        """))
        #expect(output.contains("## Contact"))
        #expect(output.hasSuffix("\n"))
    }

    @Test("runner re-emits normalized JSON")
    func runnerWritesNormalizedJSON() throws {
        let tempDirectory = try TemporaryDirectory()
        defer { tempDirectory.cleanup() }

        let inputURL = try tempDirectory.write("cv.json", contents: cliFixtureJSON)
        let outputURL = tempDirectory.url.appendingPathComponent("normalized/cv.json")

        try makeRunner().run(.init(
            dataPath: inputURL.path,
            outputPath: outputURL.path,
            format: .json
        ))

        let outputData = try Data(contentsOf: outputURL)
        let decoded = try JSONDecoder().decode(CVDocument.self, from: outputData)
        let output = try #require(String(data: outputData, encoding: .utf8))

        #expect(decoded.cv.name == "Alex Example")
        #expect(output.contains("\"frontMatter\""))
        #expect(output.contains("\"rendering\""))
        #expect(output.hasSuffix("\n"))
    }

    @Test("check mode succeeds for current output and fails for stale output")
    func checkModeComparesOutputBytes() throws {
        let tempDirectory = try TemporaryDirectory()
        defer { tempDirectory.cleanup() }

        let inputURL = try tempDirectory.write("cv.json", contents: cliFixtureJSON)
        let outputURL = tempDirectory.url.appendingPathComponent("cv/index.md")
        let options = try CVBuilderCLI.Options(dataPath: inputURL.path, outputPath: outputURL.path)

        try makeRunner().run(options)
        try makeRunner().run(.init(
            dataPath: inputURL.path,
            outputPath: outputURL.path,
            check: true
        ))

        try "stale\n".write(to: outputURL, atomically: true, encoding: .utf8)

        try expectFailure(makeRunner().run(.init(
            dataPath: inputURL.path,
            outputPath: outputURL.path,
            check: true
        ))) { failure in
            #expect(failure == .outputStale(path: outputURL.path))
        }
    }

    @Test("JSON check mode compares normalized JSON output")
    func jsonCheckModeUsesSelectedFormat() throws {
        let tempDirectory = try TemporaryDirectory()
        defer { tempDirectory.cleanup() }

        let inputURL = try tempDirectory.write("cv.json", contents: cliFixtureJSON)
        let outputURL = tempDirectory.url.appendingPathComponent("cv.normalized.json")

        try makeRunner().run(.init(
            dataPath: inputURL.path,
            outputPath: outputURL.path,
            format: .json
        ))
        try makeRunner().run(.init(
            dataPath: inputURL.path,
            outputPath: outputURL.path,
            format: .json,
            check: true
        ))

        try expectFailure(makeRunner().run(.init(
            dataPath: inputURL.path,
            outputPath: outputURL.path,
            check: true
        ))) { failure in
            #expect(failure == .outputStale(path: outputURL.path))
        }
    }

    @Test("runner reports invalid JSON, missing check output, and write failures")
    func runnerReportsUserFacingFailures() throws {
        let tempDirectory = try TemporaryDirectory()
        defer { tempDirectory.cleanup() }

        let invalidInputURL = try tempDirectory.write("invalid.json", contents: "{")
        let validInputURL = try tempDirectory.write("cv.json", contents: cliFixtureJSON)
        let blockedURL = try tempDirectory.write("blocked", contents: "")
        let unwritableOutputURL = blockedURL.appendingPathComponent("cv.md")
        let missingOutputURL = tempDirectory.url.appendingPathComponent("missing.md")

        try expectFailure(makeRunner().run(.init(
            dataPath: invalidInputURL.path,
            outputPath: missingOutputURL.path
        ))) { failure in
            guard case let .invalidJSON(path, reason) = failure else {
                Issue.record("Expected invalidJSON, got \(failure)")
                return
            }
            #expect(path == invalidInputURL.path)
            #expect(!reason.isEmpty)
        }

        try expectFailure(makeRunner().run(.init(
            dataPath: validInputURL.path,
            outputPath: missingOutputURL.path,
            check: true
        ))) { failure in
            #expect(failure == .outputMissing(path: missingOutputURL.path))
        }

        try expectFailure(makeRunner().run(.init(
            dataPath: validInputURL.path,
            outputPath: unwritableOutputURL.path
        ))) { failure in
            guard case let .outputWriteFailed(path, reason) = failure else {
                Issue.record("Expected outputWriteFailed, got \(failure)")
                return
            }
            #expect(path == unwritableOutputURL.path)
            #expect(!reason.isEmpty)
        }
    }

    @Test("programmatic options reject empty paths")
    func programmaticOptionsRejectEmptyPaths() throws {
        try expectFailure(CVBuilderCLI.Options(dataPath: "", outputPath: "cv.md")) { failure in
            #expect(failure == .missingValue(option: "--data"))
        }

        try expectFailure(CVBuilderCLI.Options(dataPath: "cv.json", outputPath: "")) { failure in
            #expect(failure == .missingValue(option: "--out"))
        }
    }

    private func makeRunner() -> CVBuilderCLI.Runner {
        CVBuilderCLI.Runner(fileSystem: CVBuilderCLI.LocalFileSystem(fileManager: .default))
    }

    private func expectFailure(
        _ operation: @autoclosure () throws -> some Any,
        validate: (CVBuilderCLI.Failure) -> Void
    ) throws {
        do {
            _ = try operation()
            Issue.record("Expected CVBuilderCLI.Failure")
        } catch let failure as CVBuilderCLI.Failure {
            validate(failure)
        } catch {
            Issue.record("Expected CVBuilderCLI.Failure, got \(error)")
        }
    }
}

private struct TemporaryDirectory {
    let url: URL

    init() throws {
        url = FileManager.default.temporaryDirectory.appendingPathComponent(
            "CVBuilderCLITests-\(UUID().uuidString)",
            isDirectory: true
        )
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }

    func write(_ relativePath: String, contents: String) throws -> URL {
        let fileURL = url.appendingPathComponent(relativePath)
        let directoryURL = fileURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try contents.write(to: fileURL, atomically: true, encoding: .utf8)

        return fileURL
    }

    func cleanup() {
        try? FileManager.default.removeItem(at: url)
    }
}

private let cliFixtureJSON = """
{
  "frontMatter": {
    "slug": "cli-cv",
    "title": "CLI CV"
  },
  "cv": {
    "id": "00000000-0000-0000-0000-000000000301",
    "name": "Alex Example",
    "title": "CLI-focused Swift Engineer",
    "summary": "Builds file-driven Swift tooling.",
    "contactInfo": {
      "email": "alex@example.com",
      "phone": "+1 555 010 0301",
      "location": "Example City"
    }
  }
}
"""
