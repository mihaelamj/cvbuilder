import CVBuilder

public extension CVBuilderCLI {
    /// User-facing failures reported by the `cvbuilder` command.
    enum Failure: Swift.Error, Equatable, Sendable {
        case missingRequiredOption(String)
        case missingValue(option: String)
        case unknownOption(String)
        case unexpectedArgument(String)
        case unknownFormat(String)
        case unknownInputFormat(String)
        case unknownFrontMatterProfile(String)
        case inputReadFailed(path: String, reason: String)
        case invalidJSON(path: String, reason: String)
        case schemaValidationUnavailable(reason: String)
        case outputAlreadyExists(path: String)
        case outputReadFailed(path: String, reason: String)
        case outputMissing(path: String)
        case outputStale(path: String)
        case cannotCheckStandardOutput
        case outputEncodingFailed
        case outputWriteFailed(path: String, reason: String)
        case standardOutputWriteFailed(reason: String)

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
            case let .unknownInputFormat(inputFormat):
                "unknown input format \(inputFormat). Allowed values: \(CVBuilderCLI.InputFormat.allowedValuesDescription)"
            case let .unknownFrontMatterProfile(profile):
                "unknown front matter profile \(profile). Allowed values: \(FrontMatterProfile.allowedValuesDescription)"
            case let .inputReadFailed(path, reason):
                "could not read \(path): \(reason)"
            case let .invalidJSON(path, reason):
                "invalid CVDocument JSON in \(path): \(reason)"
            case let .schemaValidationUnavailable(reason):
                "could not validate against embedded schema: \(reason)"
            case let .outputAlreadyExists(path):
                "refusing to overwrite \(path). Pass --force to replace it"
            case let .outputReadFailed(path, reason):
                "could not read output \(path): \(reason)"
            case let .outputMissing(path):
                "check failed because \(path) does not exist"
            case let .outputStale(path):
                "check failed because \(path) is not current"
            case .cannotCheckStandardOutput:
                "check mode cannot compare standard output"
            case .outputEncodingFailed:
                "could not encode output as UTF-8"
            case let .outputWriteFailed(path, reason):
                "could not write \(path): \(reason)"
            case let .standardOutputWriteFailed(reason):
                "could not write standard output: \(reason)"
            }
        }
    }
}

extension CVBuilderCLI.Failure: CustomStringConvertible {
    public var description: String {
        message
    }
}
