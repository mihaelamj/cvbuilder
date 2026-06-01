public extension CVBuilderCLI {
    /// Output formats supported by the `cvbuilder` command.
    enum Format: String, CaseIterable, Equatable, Sendable {
        case markdown
        case json

        init(argument: String) throws {
            guard let format = Self(rawValue: argument) else {
                throw CVBuilderCLI.Failure.unknownFormat(argument)
            }

            self = format
        }

        static var allowedValuesDescription: String {
            allCases.map(\.rawValue).joined(separator: ", ")
        }
    }
}
