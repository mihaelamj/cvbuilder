public extension CVBuilderCLI {
    /// Parsed options for `cvbuilder --validate`.
    struct ValidationOptions: Equatable, Sendable {
        /// Path to the input `CVDocument` JSON file or `-` for standard input.
        public let dataPath: String

        /// Creates validated validation options for programmatic execution.
        public init(dataPath: String) throws {
            guard !dataPath.isEmpty else {
                throw Failure.missingValue(option: "--data")
            }

            self.dataPath = dataPath
        }

        /// Parses command-line arguments for validation mode.
        public static func parse(_ arguments: [String]) throws -> ValidationOptions {
            var parser = Parser(arguments: arguments)
            return try parser.parse()
        }
    }
}

private extension CVBuilderCLI.ValidationOptions {
    struct Parser {
        let arguments: [String]
        var dataPath: String?
        var sawValidate = false
        var index: Int

        init(arguments: [String]) {
            self.arguments = arguments
            index = arguments.startIndex
        }

        mutating func parse() throws -> CVBuilderCLI.ValidationOptions {
            while index < arguments.endIndex {
                try consume(arguments[index])
            }

            guard sawValidate else {
                throw CVBuilderCLI.Failure.missingRequiredOption("--validate")
            }

            guard let dataPath else {
                throw CVBuilderCLI.Failure.missingRequiredOption("--data <path>")
            }

            return try CVBuilderCLI.ValidationOptions(dataPath: dataPath)
        }

        mutating func consume(_ argument: String) throws {
            if argument == "--validate" {
                sawValidate = true
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
            default:
                return false
            }

            return true
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
