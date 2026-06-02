import Foundation

extension CVBuilderCLI {
    enum JSONValue: Decodable, Equatable {
        case array([JSONValue])
        case bool(Bool)
        case integer(Int64)
        case null
        case number(Double)
        case object([String: JSONValue])
        case string(String)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if container.decodeNil() {
                self = .null
            } else if let value = try? container.decode(Bool.self) {
                self = .bool(value)
            } else if let value = try? container.decode(Int64.self) {
                // Decode integers exactly so the validator's view matches the
                // model decoder for values beyond Double's 2^53 precision.
                self = .integer(value)
            } else if let value = try? container.decode(Double.self) {
                self = .number(value)
            } else if let value = try? container.decode(String.self) {
                self = .string(value)
            } else if let value = try? container.decode([JSONValue].self) {
                self = .array(value)
            } else if let value = try? container.decode([String: JSONValue].self) {
                self = .object(value)
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Unsupported JSON value",
                )
            }
        }

        var arrayValue: [JSONValue]? {
            guard case let .array(value) = self else {
                return nil
            }
            return value
        }

        var kind: String {
            switch self {
            case .array:
                "array"
            case .bool:
                "boolean"
            case .integer, .number:
                "number"
            case .null:
                "null"
            case .object:
                "object"
            case .string:
                "string"
            }
        }

        var numberValue: Double? {
            switch self {
            case let .integer(value):
                Double(value)
            case let .number(value):
                value
            default:
                nil
            }
        }

        /// The exact integer value when this is an integer token, preserved
        /// without the precision loss of a `Double` round-trip.
        var integerValue: Int64? {
            guard case let .integer(value) = self else {
                return nil
            }
            return value
        }

        var objectValue: [String: JSONValue]? {
            guard case let .object(value) = self else {
                return nil
            }
            return value
        }

        var stringArrayValue: [String]? {
            arrayValue?.compactMap(\.stringValue)
        }

        var stringValue: String? {
            guard case let .string(value) = self else {
                return nil
            }
            return value
        }
    }
}
