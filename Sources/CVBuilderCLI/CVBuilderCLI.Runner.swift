import CVBuilder
import Foundation

extension CVBuilderCLI {
    /// Executes validated `cvbuilder` options against the local file system.
    public struct Runner {
        private let fileManager: FileManager

        /// Creates a runner with its file-system dependency supplied by the caller.
        public init(fileManager: FileManager) {
            self.fileManager = fileManager
        }

        /// Executes the command options by writing or checking the requested output.
        public func run(_ options: Options) throws {
            let document = try readDocument(atPath: options.dataPath)
            let output = try output(for: document, format: options.format)
            let outputData = Data(output.utf8)

            if options.check {
                try check(outputData, atPath: options.outputPath)
            } else {
                try write(outputData, toPath: options.outputPath)
            }
        }

        func output(for document: CVDocument, format: Format) throws -> String {
            switch format {
            case .markdown:
                "\(Rendering.MarkdownDocumentRenderer().render(document))\n"
            case .json:
                try "\(normalizedJSON(for: document))\n"
            }
        }

        private func readDocument(atPath path: String) throws -> CVDocument {
            let inputURL = URL(fileURLWithPath: path)
            let inputData: Data

            do {
                inputData = try Data(contentsOf: inputURL)
            } catch {
                throw Failure.inputReadFailed(path: path, reason: error.localizedDescription)
            }

            do {
                return try JSONDecoder().decode(CVDocument.self, from: inputData)
            } catch {
                throw Failure.invalidJSON(path: path, reason: String(describing: error))
            }
        }

        private func normalizedJSON(for document: CVDocument) throws -> String {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(document)
            guard let output = String(data: data, encoding: .utf8) else {
                throw Failure.outputEncodingFailed
            }

            return output
        }

        private func check(_ expectedData: Data, atPath path: String) throws {
            let outputURL = URL(fileURLWithPath: path)
            guard fileManager.fileExists(atPath: outputURL.path) else {
                throw Failure.outputMissing(path: path)
            }

            let existingData: Data
            do {
                existingData = try Data(contentsOf: outputURL)
            } catch {
                throw Failure.outputReadFailed(path: path, reason: error.localizedDescription)
            }

            guard existingData == expectedData else {
                throw Failure.outputStale(path: path)
            }
        }

        private func write(_ outputData: Data, toPath path: String) throws {
            let outputURL = URL(fileURLWithPath: path)
            let outputDirectory = outputURL.deletingLastPathComponent()

            do {
                try fileManager.createDirectory(
                    at: outputDirectory,
                    withIntermediateDirectories: true
                )
                try outputData.write(to: outputURL, options: .atomic)
            } catch {
                throw Failure.outputWriteFailed(path: path, reason: error.localizedDescription)
            }
        }
    }
}
