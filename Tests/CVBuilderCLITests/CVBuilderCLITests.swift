import CVBuilder
import CVBuilderCLI
import Foundation
import Testing

@Suite("CVBuilderCLI")
struct CVBuilderCLITests {
    @Test("command parser accepts help without data or output paths")
    func commandParserAcceptsHelp() throws {
        #expect(try CVBuilderCLI.Command.parse(["--help"]) == .help)
        #expect(try CVBuilderCLI.Command.parse(["-h"]) == .help)
        #expect(try CVBuilderCLI.Command.parse(["--", "--help"]) == .help)
        #expect(try CVBuilderCLI.Command.parse(["--print-schema"]) == .printSchema)
        #expect(try CVBuilderCLI.Command.parse(["--data", "cv.json", "--validate"]) == .validate(.init(dataPath: "cv.json")))
        #expect(try CVBuilderCLI.Command.parse(["--init", "cv.json"]) == .initialize(.init(outputPath: "cv.json")))
        #expect(try CVBuilderCLI.Command.parse(["--init", "cv.json", "--force"]) == .initialize(.init(outputPath: "cv.json", force: true)))
        #expect(try CVBuilderCLI.Command.parse([
            "--",
            "--data",
            "cv.json",
            "--out",
            "cv.md",
        ]) == .run(.init(dataPath: "cv.json", outputPath: "cv.md")))
    }

    @Test("usage text documents supported options and examples")
    func usageTextDocumentsSupportedOptions() {
        let usage = CVBuilderCLI.Usage.text

        #expect(usage.contains("Usage: cvbuilder"))
        #expect(usage.contains("--data <path|->"))
        #expect(usage.contains("--out <path|->"))
        #expect(usage.contains("--format <format>"))
        #expect(usage.contains("markdown or json"))
        #expect(usage.contains("--front-matter-profile <profile>"))
        #expect(usage.contains("generic, toucan, hugo, or jekyll"))
        #expect(usage.contains("--check"))
        #expect(usage.contains("--validate"))
        #expect(usage.contains("--print-schema"))
        #expect(usage.contains("--init <path>"))
        #expect(usage.contains("--force"))
        #expect(usage.contains("cvbuilder --data cv.json --out cv/index.md --front-matter-profile hugo"))
        #expect(usage.contains("cat cv.json | cvbuilder --data - --out -"))
        #expect(usage.contains("-h, --help"))
        #expect(!usage.localizedCaseInsensitiveContains("pdf"))
        #expect(!usage.localizedCaseInsensitiveContains("html"))
        #expect(!usage.localizedCaseInsensitiveContains("ats"))
    }

    @Test("parser accepts required paths, format, and check mode")
    func parserAcceptsOptions() throws {
        let options = try CVBuilderCLI.Options.parse([
            "--data",
            "cv.json",
            "--out=cv/index.md",
            "--format",
            "json",
            "--front-matter-profile=hugo",
            "--check",
        ])

        let expected = try CVBuilderCLI.Options(
            dataPath: "cv.json",
            outputPath: "cv/index.md",
            format: .json,
            frontMatterProfile: .hugo,
            check: true,
        )

        #expect(options == expected)

        #expect(try CVBuilderCLI.Options.parse([
            "--data",
            "-",
            "--out",
            "-",
        ]) == .init(dataPath: "-", outputPath: "-"))
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
        let unknownProfileArguments = ["--data", "cv.json", "--out", "cv.md", "--front-matter-profile", "astro"]
        try expectFailure(CVBuilderCLI.Options.parse(unknownProfileArguments)) { failure in
            #expect(failure == .unknownFrontMatterProfile("astro"))
            #expect(failure.message.contains("generic, toucan, hugo, jekyll"))
        }
        try expectFailure(CVBuilderCLI.Options.parse(["cv.json"])) { failure in
            #expect(failure == .unexpectedArgument("cv.json"))
        }
    }

    @Test("runner validates input without writing output")
    func runnerValidatesInputWithoutWriting() throws {
        let tempDirectory = try TemporaryDirectory()
        defer { tempDirectory.cleanup() }

        let inputURL = try tempDirectory.write("cv.json", contents: cliFixtureJSON)
        let missingEmailInputURL = try tempDirectory.write("missing-email.json", contents: missingEmailJSON)
        let invalidMonthInputURL = try tempDirectory.write("invalid-month.json", contents: invalidMonthJSON)
        let outputURL = tempDirectory.url.appendingPathComponent("cv/index.md")

        try makeRunner().validate(.init(dataPath: inputURL.path))
        #expect(!FileManager.default.fileExists(atPath: outputURL.path))

        try expectFailure(makeRunner().validate(.init(dataPath: missingEmailInputURL.path))) { failure in
            guard case let .invalidJSON(path, reason) = failure else {
                Issue.record("Expected invalidJSON, got \(failure)")
                return
            }
            #expect(path == missingEmailInputURL.path)
            #expect(reason.contains("cv.contactInfo.email"))
        }

        try expectFailure(makeRunner().validate(.init(dataPath: invalidMonthInputURL.path))) { failure in
            guard case let .invalidJSON(path, reason) = failure else {
                Issue.record("Expected invalidJSON, got \(failure)")
                return
            }
            #expect(path == invalidMonthInputURL.path)
            #expect(reason.contains("$.cv.experience[0].period.start.month"))
            #expect(reason.contains("above maximum"))
        }
    }

    @Test("runner prints embedded JSON Schema without filesystem access")
    func runnerPrintsCheckedInJSONSchema() throws {
        let standardIO = MemoryStandardIO()
        try makeRunner(fileSystem: UnavailableFileSystem(), standardIO: standardIO).printSchema()

        let expectedSchema = try Data(contentsOf: repositoryRoot().appendingPathComponent("Schemas/cvdocument.schema.json"))
        #expect(standardIO.output == expectedSchema)
    }

    @Test("runner initializes starter document and protects existing files")
    func runnerInitializesStarterDocument() throws {
        let tempDirectory = try TemporaryDirectory()
        defer { tempDirectory.cleanup() }

        let outputURL = tempDirectory.url.appendingPathComponent("cv.json")
        try makeRunner().initialize(.init(outputPath: outputURL.path))

        let data = try Data(contentsOf: outputURL)
        let decoded = try JSONDecoder().decode(CVDocument.self, from: data)
        let output = try #require(String(data: data, encoding: .utf8))

        #expect(decoded.cv.name == "Demo Candidate")
        #expect(decoded.cv.contactInfo.email == "demo.candidate@example.com")
        #expect(decoded.cv.skills.map(\.name) == ["Swift", "Linux"])
        #expect(output.hasSuffix("\n"))

        try expectFailure(makeRunner().initialize(.init(outputPath: outputURL.path))) { failure in
            #expect(failure == .outputAlreadyExists(path: outputURL.path))
        }

        try "stale\n".write(to: outputURL, atomically: true, encoding: .utf8)
        try makeRunner().initialize(.init(outputPath: outputURL.path, force: true))

        let overwritten = try String(contentsOf: outputURL, encoding: .utf8)
        #expect(overwritten.contains("\"name\": \"Demo Candidate\""))
    }

    @Test("runner composes through stdin and stdout")
    func runnerComposesThroughStandardInputAndOutput() throws {
        let standardIO = MemoryStandardIO(input: Data(cliFixtureJSON.utf8))
        try makeRunner(standardIO: standardIO).run(.init(dataPath: "-", outputPath: "-"))

        let output = try #require(String(data: standardIO.output, encoding: .utf8))
        #expect(output.contains("# Alex Example"))
        #expect(output.contains("## Contact"))
        #expect(output.hasSuffix("\n"))

        try expectFailure(makeRunner(standardIO: standardIO).run(.init(
            dataPath: "-",
            outputPath: "-",
            check: true,
        ))) { failure in
            #expect(failure == .cannotCheckStandardOutput)
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

    @Test("runner applies front matter profile overrides")
    func runnerAppliesFrontMatterProfileOverrides() throws {
        let tempDirectory = try TemporaryDirectory()
        defer { tempDirectory.cleanup() }

        let inputURL = try tempDirectory.write("cv.json", contents: cliFixtureJSON)
        let outputURL = tempDirectory.url.appendingPathComponent("cv/index.md")

        try makeRunner().run(.init(
            dataPath: inputURL.path,
            outputPath: outputURL.path,
            frontMatterProfile: .hugo,
        ))

        let output = try String(contentsOf: outputURL, encoding: .utf8)
        #expect(output.hasPrefix("""
        +++
        title = "CLI CV"
        slug = "cli-cv"
        +++
        """))
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
            format: .json,
            frontMatterProfile: .jekyll,
        ))

        let outputData = try Data(contentsOf: outputURL)
        let decoded = try JSONDecoder().decode(CVDocument.self, from: outputData)
        let output = try #require(String(data: outputData, encoding: .utf8))

        #expect(decoded.cv.name == "Alex Example")
        #expect(decoded.rendering.frontMatterProfile == .jekyll)
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
            check: true,
        ))

        try "stale\n".write(to: outputURL, atomically: true, encoding: .utf8)

        try expectFailure(makeRunner().run(.init(
            dataPath: inputURL.path,
            outputPath: outputURL.path,
            check: true,
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
            format: .json,
            frontMatterProfile: .jekyll,
        ))
        try makeRunner().run(.init(
            dataPath: inputURL.path,
            outputPath: outputURL.path,
            format: .json,
            frontMatterProfile: .jekyll,
            check: true,
        ))

        try expectFailure(makeRunner().run(.init(
            dataPath: inputURL.path,
            outputPath: outputURL.path,
            check: true,
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
            outputPath: missingOutputURL.path,
        ))) { failure in
            guard case let .invalidJSON(path, reason) = failure else {
                Issue.record("Expected invalidJSON, got \(failure)")
                return
            }
            #expect(path == invalidInputURL.path)
            #expect(!reason.isEmpty)
        }

        let missingEmailInputURL = try tempDirectory.write("missing-email.json", contents: missingEmailJSON)
        try expectFailure(makeRunner().run(.init(
            dataPath: missingEmailInputURL.path,
            outputPath: missingOutputURL.path,
        ))) { failure in
            guard case let .invalidJSON(path, reason) = failure else {
                Issue.record("Expected invalidJSON, got \(failure)")
                return
            }
            #expect(path == missingEmailInputURL.path)
            #expect(reason.contains("cv.contactInfo.email"))
        }

        try expectFailure(makeRunner().run(.init(
            dataPath: validInputURL.path,
            outputPath: missingOutputURL.path,
            check: true,
        ))) { failure in
            #expect(failure == .outputMissing(path: missingOutputURL.path))
        }

        try expectFailure(makeRunner().run(.init(
            dataPath: validInputURL.path,
            outputPath: unwritableOutputURL.path,
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

    private func makeRunner(
        fileSystem: any CVBuilderCLI.FileSystem = CVBuilderCLI.LocalFileSystem(fileManager: .default),
        standardIO: any CVBuilderCLI.StandardIO = MemoryStandardIO(),
    ) -> CVBuilderCLI.Runner {
        CVBuilderCLI.Runner(
            fileSystem: fileSystem,
            standardIO: standardIO,
        )
    }

    private func expectFailure(
        _ operation: @autoclosure () throws -> some Any,
        validate: (CVBuilderCLI.Failure) -> Void,
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

private final class MemoryStandardIO: CVBuilderCLI.StandardIO {
    private let input: Data
    private(set) var output = Data()

    init(input: Data = Data()) {
        self.input = input
    }

    func readStandardInput() throws -> Data {
        input
    }

    func writeStandardOutput(_ data: Data) throws {
        output.append(data)
    }
}

private struct UnavailableFileSystem: CVBuilderCLI.FileSystem {
    enum Error: Swift.Error {
        case unavailable
    }

    func readFile(atPath _: String) throws -> Data {
        throw Error.unavailable
    }

    func fileExists(atPath _: String) -> Bool {
        false
    }

    func createDirectory(at _: URL, withIntermediateDirectories _: Bool) throws {
        throw Error.unavailable
    }

    func write(_: Data, to _: URL) throws {
        throw Error.unavailable
    }
}

private struct TemporaryDirectory {
    let url: URL

    init() throws {
        url = FileManager.default.temporaryDirectory.appendingPathComponent(
            "CVBuilderCLITests-\(UUID().uuidString)",
            isDirectory: true,
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

private func repositoryRoot() -> URL {
    URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
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

private let missingEmailJSON = """
{
  "cv": {
    "name": "Alex Example",
    "title": "CLI-focused Swift Engineer",
    "summary": "Builds file-driven Swift tooling.",
    "contactInfo": {
      "phone": "+1 555 010 0301",
      "location": "Example City"
    }
  }
}
"""

private let invalidMonthJSON = """
{
  "cv": {
    "name": "Alex Example",
    "title": "CLI-focused Swift Engineer",
    "summary": "Builds file-driven Swift tooling.",
    "contactInfo": {
      "email": "alex@example.com",
      "phone": "+1 555 010 0301",
      "location": "Example City"
    },
    "experience": [
      {
        "company": {
          "name": "Example Systems"
        },
        "role": {
          "title": "Engineer",
          "seniority": "Senior"
        },
        "period": {
          "start": {
            "month": 13,
            "year": 2026
          },
          "end": {
            "month": 12,
            "year": 2026
          }
        }
      }
    ]
  }
}
"""
