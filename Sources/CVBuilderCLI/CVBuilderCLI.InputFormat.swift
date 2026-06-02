public extension CVBuilderCLI {
    /// Input formats the `cvbuilder` command can read.
    ///
    /// The default `cvDocument` reads canonical `CVDocument` JSON. `jsonResume`
    /// reads a [jsonresume.org](https://jsonresume.org) document and converts it
    /// to a `CVDocument` before rendering or re-encoding.
    enum InputFormat: String, CaseIterable, Equatable, Sendable {
        case cvDocument = "cv-document"
        case jsonResume = "json-resume"

        init(argument: String) throws {
            guard let inputFormat = Self(rawValue: argument) else {
                throw CVBuilderCLI.Failure.unknownInputFormat(argument)
            }

            self = inputFormat
        }

        static var allowedValuesDescription: String {
            allCases.map(\.rawValue).joined(separator: ", ")
        }
    }
}
