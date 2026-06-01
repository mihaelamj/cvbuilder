extension CVBuilderCLI {
    /// User-facing failures reported by the `cvbuilder` command.
    public enum Failure: Swift.Error, Equatable, Sendable {
        case missingRequiredOption(String)
        case missingValue(option: String)
        case unknownOption(String)
        case unexpectedArgument(String)
        case unknownFormat(String)
        case inputReadFailed(path: String, reason: String)
        case invalidJSON(path: String, reason: String)
        case outputReadFailed(path: String, reason: String)
        case outputMissing(path: String)
        case outputStale(path: String)
        case outputEncodingFailed
        case outputWriteFailed(path: String, reason: String)

        public var message: String {
            switch self {
            case let .missingRequiredOption(option):
                "missing required option \(option)"
            case let .missingValue(option):
                "missing value for \(option)"
            case let .unknownOption(option):
                "unknown option \(option)"
            case let .unexpectedArgument(argument):
                "unexpected argument \(argument)"
            case let .unknownFormat(format):
                "unknown format \(format). Allowed values: \(CVBuilderCLI.Format.allowedValuesDescription)"
            case let .inputReadFailed(path, reason):
                "could not read \(path): \(reason)"
            case let .invalidJSON(path, reason):
                "invalid CVDocument JSON in \(path): \(reason)"
            case let .outputReadFailed(path, reason):
                "could not read output \(path): \(reason)"
            case let .outputMissing(path):
                "check failed because \(path) does not exist"
            case let .outputStale(path):
                "check failed because \(path) is not current"
            case .outputEncodingFailed:
                "could not encode output as UTF-8"
            case let .outputWriteFailed(path, reason):
                "could not write \(path): \(reason)"
            }
        }
    }
}

extension CVBuilderCLI.Failure: CustomStringConvertible {
    public var description: String {
        message
    }
}
