import CVBuilder
import Foundation

public extension CVBuilderCLI {
    /// Executes validated `cvbuilder` options against an injected file-system boundary.
    struct Runner {
        private let fileSystem: any FileSystem
        private let standardIO: any StandardIO

        /// Creates a runner with its file-system and standard-IO dependencies supplied by the caller.
        public init(fileSystem: any FileSystem, standardIO: any StandardIO = LocalStandardIO()) {
            self.fileSystem = fileSystem
            self.standardIO = standardIO
        }

        /// Executes a parsed command.
        public func run(_ command: Command) throws {
            switch command {
            case .help:
                try writeStandardOutput(Data("\(Usage.text)\n".utf8))
            case let .initialize(options):
                try initialize(options)
            case .printSchema:
                try printSchema()
            case let .run(options):
                try run(options)
            case let .validate(options):
                try validate(options)
            }
        }

        /// Executes the command options by writing or checking the requested output.
        public func run(_ options: Options) throws {
            let document = try document(
                readDocument(atPath: options.dataPath),
                overridingFrontMatterProfile: options.frontMatterProfile,
            )
            let output = try output(for: document, format: options.format)
            let outputData = Data(output.utf8)

            if options.check {
                try check(outputData, atPath: options.outputPath)
            } else {
                try write(outputData, toPath: options.outputPath)
            }
        }

        /// Validates the input document without writing generated output.
        public func validate(_ options: ValidationOptions) throws {
            _ = try readDocument(atPath: options.dataPath)
        }

        /// Writes the canonical embedded JSON Schema to standard output.
        public func printSchema() throws {
            try writeStandardOutput(SchemaDocument.data)
        }

        /// Writes a minimal starter document.
        public func initialize(_ options: InitOptions) throws {
            let outputURL = URL(fileURLWithPath: options.outputPath)
            if fileSystem.fileExists(atPath: outputURL.path), !options.force {
                throw Failure.outputAlreadyExists(path: options.outputPath)
            }

            try write(StarterDocument.data, toPath: options.outputPath)
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
            let inputData: Data

            do {
                inputData = try readData(atPath: path)
            } catch {
                throw Failure.inputReadFailed(path: path, reason: error.localizedDescription)
            }

            try validateInputData(inputData, path: path)

            do {
                return try JSONDecoder().decode(CVDocument.self, from: inputData)
            } catch {
                throw Failure.invalidJSON(path: path, reason: decodingFailureReason(for: error))
            }
        }

        private func validateInputData(_ data: Data, path: String) throws {
            let value: JSONValue
            do {
                value = try JSONDecoder().decode(JSONValue.self, from: data)
            } catch {
                throw Failure.invalidJSON(path: path, reason: decodingFailureReason(for: error))
            }

            let validator: SchemaSubsetValidator
            do {
                let schema = try JSONDecoder().decode(JSONValue.self, from: SchemaDocument.data)
                validator = try SchemaSubsetValidator(schema: schema)
            } catch {
                throw Failure.schemaValidationUnavailable(reason: String(describing: error))
            }

            let errors = validator.validate(value)
            guard errors.isEmpty else {
                let reason = errors
                    .prefix(5)
                    .joined(separator: "; ")
                throw Failure.invalidJSON(path: path, reason: "schema validation failed: \(reason)")
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

        private func document(
            _ document: CVDocument,
            overridingFrontMatterProfile profile: FrontMatterProfile?,
        ) -> CVDocument {
            guard let profile else {
                return document
            }

            return CVDocument(
                frontMatter: document.frontMatter,
                cv: document.cv,
                links: document.links,
                publicEvidence: document.publicEvidence,
                rendering: RenderingOptions(
                    frontMatterProfile: profile,
                    mode: document.rendering.mode,
                    recentCompanyCount: document.rendering.recentCompanyCount,
                    selectedExperienceIDs: document.rendering.selectedExperienceIDs,
                    maxBulletsPerProject: document.rendering.maxBulletsPerProject,
                    nestProjectsUnderRoles: document.rendering.nestProjectsUnderRoles,
                    compactGroupedSkills: document.rendering.compactGroupedSkills,
                    omitEmptySections: document.rendering.omitEmptySections,
                ),
            )
        }

        private func check(_ expectedData: Data, atPath path: String) throws {
            guard path != "-" else {
                throw Failure.cannotCheckStandardOutput
            }

            let outputURL = URL(fileURLWithPath: path)
            guard fileSystem.fileExists(atPath: outputURL.path) else {
                throw Failure.outputMissing(path: path)
            }

            let existingData: Data
            do {
                existingData = try fileSystem.readFile(atPath: outputURL.path)
            } catch {
                throw Failure.outputReadFailed(path: path, reason: error.localizedDescription)
            }

            guard existingData == expectedData else {
                throw Failure.outputStale(path: path)
            }
        }

        private func write(_ outputData: Data, toPath path: String) throws {
            guard path != "-" else {
                try writeStandardOutput(outputData)
                return
            }

            let outputURL = URL(fileURLWithPath: path)
            let outputDirectory = outputURL.deletingLastPathComponent()

            do {
                try fileSystem.createDirectory(
                    at: outputDirectory,
                    withIntermediateDirectories: true,
                )
                try fileSystem.write(outputData, to: outputURL)
            } catch {
                throw Failure.outputWriteFailed(path: path, reason: error.localizedDescription)
            }
        }

        private func readData(atPath path: String) throws -> Data {
            if path == "-" {
                return try standardIO.readStandardInput()
            }

            return try fileSystem.readFile(atPath: path)
        }

        private func writeStandardOutput(_ data: Data) throws {
            do {
                try standardIO.writeStandardOutput(data)
            } catch {
                throw Failure.standardOutputWriteFailed(reason: error.localizedDescription)
            }
        }
    }
}

private extension CVBuilderCLI.Runner {
    func decodingFailureReason(for error: any Swift.Error) -> String {
        switch error {
        case let DecodingError.keyNotFound(key, context):
            let path = codingPathDescription(context.codingPath + [key])
            return "missing required field `\(path)`: \(context.debugDescription)"
        case let DecodingError.valueNotFound(type, context):
            let path = codingPathDescription(context.codingPath)
            return "missing non-null `\(String(describing: type))` at `\(path)`: \(context.debugDescription)"
        case let DecodingError.typeMismatch(type, context):
            let path = codingPathDescription(context.codingPath)
            return "expected `\(String(describing: type))` at `\(path)`: \(context.debugDescription)"
        case let DecodingError.dataCorrupted(context):
            let path = codingPathDescription(context.codingPath)
            return "invalid value at `\(path)`: \(context.debugDescription)"
        default:
            return error.localizedDescription
        }
    }

    func codingPathDescription(_ codingPath: [any CodingKey]) -> String {
        guard !codingPath.isEmpty else {
            return "document root"
        }

        var output = ""
        for key in codingPath {
            if let index = key.intValue {
                output += "[\(index)]"
            } else {
                if !output.isEmpty {
                    output += "."
                }
                output += key.stringValue
            }
        }

        return output
    }
}
