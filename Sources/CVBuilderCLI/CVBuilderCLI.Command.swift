public extension CVBuilderCLI {
    /// Top-level command selected from command-line arguments.
    enum Command: Equatable, Sendable {
        case help
        case run(Options)

        /// Parses arguments after the executable name.
        public static func parse(_ arguments: [String]) throws -> Command {
            let normalizedArguments = normalized(arguments)

            if normalizedArguments.count == 1, let argument = normalizedArguments.first, isHelpArgument(argument) {
                return .help
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
    }
}
