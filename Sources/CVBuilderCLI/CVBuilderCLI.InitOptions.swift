public extension CVBuilderCLI {
    /// Parsed options for `cvbuilder --init`.
    struct InitOptions: Equatable, Sendable {
        /// Path where the starter `CVDocument` JSON should be written.
        public let outputPath: String
        /// Whether an existing file may be overwritten.
        public let force: Bool

        /// Creates validated init options for programmatic execution.
        public init(outputPath: String, force: Bool = false) throws {
            guard !outputPath.isEmpty else {
                throw Failure.missingValue(option: "--init")
            }

            self.outputPath = outputPath
            self.force = force
        }

        /// Parses command-line arguments for init mode.
        public static func parse(_ arguments: [String]) throws -> InitOptions {
            var parser = Parser(arguments: arguments)
            return try parser.parse()
        }
    }
}

private extension CVBuilderCLI.InitOptions {
    struct Parser {
        let arguments: [String]
        var outputPath: String?
        var force = false
        var index: Int

        init(arguments: [String]) {
            self.arguments = arguments
            index = arguments.startIndex
        }

        mutating func parse() throws -> CVBuilderCLI.InitOptions {
            while index < arguments.endIndex {
                try consume(arguments[index])
            }

            guard let outputPath else {
                throw CVBuilderCLI.Failure.missingRequiredOption("--init <path>")
            }

            return try CVBuilderCLI.InitOptions(outputPath: outputPath, force: force)
        }

        mutating func consume(_ argument: String) throws {
            switch argument {
            case "--force":
                force = true
                advance()
            case "--init":
                outputPath = try nextValue(option: argument)
            default:
                try reject(argument)
            }
        }

        mutating func nextValue(option: String) throws -> String {
            advance()
            guard index < arguments.endIndex else {
                throw CVBuilderCLI.Failure.missingValue(option: option)
            }

            let value = arguments[index]
            guard !value.isEmpty, !value.hasPrefix("-") else {
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
