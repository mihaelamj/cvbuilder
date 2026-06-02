import Foundation

extension CVBuilderCLI {
    enum JSONValue: Decodable, Equatable {
        case array([JSONValue])
        case bool(Bool)
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
            case .null:
                "null"
            case .number:
                "number"
            case .object:
                "object"
            case .string:
                "string"
            }
        }

        var numberValue: Double? {
            guard case let .number(value) = self else {
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
