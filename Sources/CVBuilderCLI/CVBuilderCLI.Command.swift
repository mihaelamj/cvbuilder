public extension CVBuilderCLI {
    /// Top-level command selected from command-line arguments.
    enum Command: Equatable, Sendable {
        case help
        case initialize(InitOptions)
        case printSchema
        case run(Options)
        case validate(ValidationOptions)

        /// Parses arguments after the executable name.
        public static func parse(_ arguments: [String]) throws -> Command {
            let normalizedArguments = normalized(arguments)

            if normalizedArguments.count == 1, let argument = normalizedArguments.first, isHelpArgument(argument) {
                return .help
            }

            if containsPrintSchema(normalizedArguments) {
                guard normalizedArguments == ["--print-schema"] else {
                    throw Failure.unexpectedArgument(normalizedArguments.joined(separator: " "))
                }
                return .printSchema
            }

            if containsInit(normalizedArguments) {
                return try .initialize(InitOptions.parse(normalizedArguments))
            }

            if containsValidate(normalizedArguments) {
                return try .validate(ValidationOptions.parse(normalizedArguments))
            }

            return try .run(Options.parse(normalizedArguments))
        }

        private static func isHelpArgument(_ argument: String) -> Bool {
            argument == "--help" || argument == "-h"
        }

        private static func normalized(_ arguments: [String]) -> [String] {
            guard arguments.first == "--" else {
                return arguments
            }

            return Array(arguments.dropFirst())
        }

        private static func containsPrintSchema(_ arguments: [String]) -> Bool {
            arguments.contains("--print-schema")
        }

        private static func containsInit(_ arguments: [String]) -> Bool {
            arguments.contains("--init")
        }

        private static func containsValidate(_ arguments: [String]) -> Bool {
            arguments.contains("--validate")
        }
    }
}
