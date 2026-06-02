import CVBuilder

public extension CVBuilderCLI {
    /// Parsed command-line options for a `cvbuilder` invocation.
    struct Options: Equatable, Sendable {
        /// Path to the input `CVDocument` JSON file.
        public let dataPath: String
        /// Path where the rendered Markdown or normalized JSON should be written or checked.
        public let outputPath: String
        /// Input format selected by `--from`; defaults to canonical `CVDocument` JSON.
        public let from: InputFormat
        /// Output format selected by `--format`; defaults to Markdown.
        public let format: Format
        /// Optional front matter profile override selected by the CLI.
        public let frontMatterProfile: FrontMatterProfile?
        /// Whether the command should compare output without writing.
        public let check: Bool

        /// Creates validated command options for programmatic execution.
        public init(
            dataPath: String,
            outputPath: String,
            from: InputFormat = .cvDocument,
            format: Format = .markdown,
            frontMatterProfile: FrontMatterProfile? = nil,
            check: Bool = false,
        ) throws {
            guard !dataPath.isEmpty else {
                throw Failure.missingValue(option: "--data")
            }

            guard !outputPath.isEmpty else {
                throw Failure.missingValue(option: "--out")
            }

            self.dataPath = dataPath
            self.outputPath = outputPath
            self.from = from
            self.format = format
            self.frontMatterProfile = frontMatterProfile
            self.check = check
        }

        /// Parses command-line arguments after the executable name.
        public static func parse(_ arguments: [String]) throws -> Options {
            var parser = Parser(arguments: arguments)
            return try parser.parse()
        }
    }
}

private extension CVBuilderCLI.Options {
    struct Parser {
        let arguments: [String]
        var dataPath: String?
        var outputPath: String?
        var from = CVBuilderCLI.InputFormat.cvDocument
        var format = CVBuilderCLI.Format.markdown
        var frontMatterProfile: FrontMatterProfile?
        var check = false
        var index: Int

        init(arguments: [String]) {
            self.arguments = arguments
            index = arguments.startIndex
        }

        mutating func parse() throws -> CVBuilderCLI.Options {
            while index < arguments.endIndex {
                try consume(arguments[index])
            }

            return try makeOptions()
        }

        mutating func consume(_ argument: String) throws {
            if argument == "--check" {
                check = true
                advance()
                return
            }

            if try consumeAssignedValue(argument) {
                return
            }

            if try consumeSeparatedValue(argument) {
                return
            }

            try reject(argument)
        }

        mutating func consumeAssignedValue(_ argument: String) throws -> Bool {
            guard let equalsIndex = argument.firstIndex(of: "=") else {
                return false
            }

            let option = String(argument[..<equalsIndex])
            let value = String(argument[argument.index(after: equalsIndex)...])

            switch option {
            case "--data":
                dataPath = try requiredAssignedValue(value, option: option)
            case "--out":
                outputPath = try requiredAssignedValue(value, option: option)
            case "--from":
                from = try CVBuilderCLI.InputFormat(argument: requiredAssignedValue(value, option: option))
            case "--format":
                format = try CVBuilderCLI.Format(argument: requiredAssignedValue(value, option: option))
            case "--front-matter-profile":
                frontMatterProfile = try FrontMatterProfile(argument: requiredAssignedValue(value, option: option))
            default:
                if option.hasPrefix("-") {
                    throw CVBuilderCLI.Failure.unknownOption(option)
                }
                return false
            }

            advance()
            return true
        }

        mutating func consumeSeparatedValue(_ argument: String) throws -> Bool {
            switch argument {
            case "--data":
                dataPath = try nextValue(option: argument)
            case "--out":
                outputPath = try nextValue(option: argument)
            case "--from":
                from = try CVBuilderCLI.InputFormat(argument: nextValue(option: argument))
            case "--format":
                format = try CVBuilderCLI.Format(argument: nextValue(option: argument))
            case "--front-matter-profile":
                frontMatterProfile = try FrontMatterProfile(argument: nextValue(option: argument))
            default:
                return false
            }

            return true
        }

        func makeOptions() throws -> CVBuilderCLI.Options {
            guard let dataPath else {
                throw CVBuilderCLI.Failure.missingRequiredOption("--data <path>")
            }

            guard let outputPath else {
                throw CVBuilderCLI.Failure.missingRequiredOption("--out <path>")
            }

            return try CVBuilderCLI.Options(
                dataPath: dataPath,
                outputPath: outputPath,
                from: from,
                format: format,
                frontMatterProfile: frontMatterProfile,
                check: check,
            )
        }

        func requiredAssignedValue(_ value: String, option: String) throws -> String {
            guard !value.isEmpty else {
                throw CVBuilderCLI.Failure.missingValue(option: option)
            }

            return value
        }

        mutating func nextValue(option: String) throws -> String {
            advance()
            guard index < arguments.endIndex else {
                throw CVBuilderCLI.Failure.missingValue(option: option)
            }

            let value = arguments[index]
            guard !value.isEmpty, value == "-" || !value.hasPrefix("-") else {
                throw CVBuilderCLI.Failure.missingValue(option: option)
            }

            advance()
            return value
        }

        mutating func advance() {
            index = arguments.index(after: index)
        }

        func reject(_ argument: String) throws {
            if argument.hasPrefix("-") {
                throw CVBuilderCLI.Failure.unknownOption(argument)
            }

            throw CVBuilderCLI.Failure.unexpectedArgument(argument)
        }
    }
}
