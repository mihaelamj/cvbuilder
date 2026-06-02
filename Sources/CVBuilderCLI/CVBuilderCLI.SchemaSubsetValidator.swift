import Foundation

extension CVBuilderCLI {
    struct SchemaSubsetValidator {
        private let root: JSONValue
        private let rootSchema: [String: JSONValue]

        init(schema: JSONValue) throws {
            guard case let .object(rootSchema) = schema else {
                throw ValidationSetupError.rootSchemaIsNotObject
            }

            root = schema
            self.rootSchema = rootSchema
        }

        func validate(_ value: JSONValue) -> [String] {
            validate(value, against: rootSchema, path: "$")
        }

        private func validate(
            _ value: JSONValue,
            against schema: [String: JSONValue],
            path: String,
        ) -> [String] {
            if let ref = schema["$ref"]?.stringValue {
                do {
                    return try validate(value, against: resolve(ref), path: path)
                } catch {
                    return ["\(path) cannot resolve schema reference \(ref): \(error)"]
                }
            }

            if let anyOf = schema["anyOf"]?.arrayValue {
                return validateAnyOf(value, schemas: anyOf, path: path)
            }

            if let expectedTypes = schema["type"] {
                let types = typeNames(expectedTypes)
                if !types.contains(where: { matches($0, value: value) }) {
                    return ["\(path) expected \(types.joined(separator: " or ")), got \(value.kind)"]
                }
            }

            var errors: [String] = []
            errors.append(contentsOf: validateEnum(value, schema: schema, path: path))
            errors.append(contentsOf: validateNumberBounds(value, schema: schema, path: path))
            errors.append(contentsOf: validateFormat(value, schema: schema, path: path))

            switch value {
            case let .object(object):
                errors.append(contentsOf: validateObject(object, schema: schema, path: path))
            case let .array(array):
                errors.append(contentsOf: validateArray(array, schema: schema, path: path))
            case .bool, .null, .number, .string:
                break
            }

            return errors
        }

        private func validateAnyOf(
            _ value: JSONValue,
            schemas: [JSONValue],
            path: String,
        ) -> [String] {
            let schemaObjects = schemas.compactMap(\.objectValue)
            let results = schemaObjects.map { validate(value, against: $0, path: path) }

            if results.contains(where: \.isEmpty) {
                return []
            }

            let details = results
                .flatMap { $0.prefix(2) }
                .joined(separator: "; ")
            return ["\(path) did not match any allowed schema\(details.isEmpty ? "" : ": \(details)")"]
        }

        private func validateObject(
            _ object: [String: JSONValue],
            schema: [String: JSONValue],
            path: String,
        ) -> [String] {
            var errors: [String] = []
            let properties = schema["properties"]?.objectValue ?? [:]

            for required in schema["required"]?.stringArrayValue ?? [] where object[required] == nil {
                errors.append("\(path).\(required) is required")
            }

            for (key, childValue) in object {
                let childPath = "\(path).\(key)"
                if let propertySchema = properties[key]?.objectValue {
                    errors.append(contentsOf: validate(childValue, against: propertySchema, path: childPath))
                } else if let additionalProperties = schema["additionalProperties"] {
                    errors.append(
                        contentsOf: validateAdditionalProperty(
                            childValue,
                            rule: additionalProperties,
                            path: childPath,
                        ),
                    )
                }
            }

            return errors
        }

        private func validateAdditionalProperty(
            _ value: JSONValue,
            rule: JSONValue,
            path: String,
        ) -> [String] {
            switch rule {
            case .bool(true):
                []
            case .bool(false):
                ["\(path) is not allowed"]
            case let .object(schema):
                validate(value, against: schema, path: path)
            case .array, .null, .number, .string:
                []
            }
        }

        private func validateArray(
            _ array: [JSONValue],
            schema: [String: JSONValue],
            path: String,
        ) -> [String] {
            guard let itemSchema = schema["items"]?.objectValue else {
                return []
            }

            return array.enumerated().flatMap { index, value in
                validate(value, against: itemSchema, path: "\(path)[\(index)]")
            }
        }

        private func validateEnum(
            _ value: JSONValue,
            schema: [String: JSONValue],
            path: String,
        ) -> [String] {
            guard let allowedValues = schema["enum"]?.arrayValue else {
                return []
            }

            return allowedValues.contains(value) ? [] : ["\(path) is not one of the allowed values"]
        }

        private func validateNumberBounds(
            _ value: JSONValue,
            schema: [String: JSONValue],
            path: String,
        ) -> [String] {
            guard let number = value.numberValue else {
                return []
            }

            var errors: [String] = []
            if let minimum = schema["minimum"]?.numberValue, number < minimum {
                errors.append("\(path) is below minimum \(minimum)")
            }
            if let maximum = schema["maximum"]?.numberValue, number > maximum {
                errors.append("\(path) is above maximum \(maximum)")
            }
            return errors
        }

        private func validateFormat(
            _ value: JSONValue,
            schema: [String: JSONValue],
            path: String,
        ) -> [String] {
            guard
                let format = schema["format"]?.stringValue,
                let string = value.stringValue
            else {
                return []
            }

            switch format {
            case "uuid":
                return UUID(uuidString: string) == nil ? ["\(path) is not a UUID"] : []
            case "uri":
                return URL(string: string)?.scheme == nil ? ["\(path) is not an absolute URI"] : []
            default:
                return []
            }
        }

        private func typeNames(_ value: JSONValue) -> [String] {
            if let type = value.stringValue {
                return [type]
            }

            return value.arrayValue?.compactMap(\.stringValue) ?? []
        }

        private func matches(_ type: String, value: JSONValue) -> Bool {
            switch (type, value) {
            case ("array", .array),
                 ("boolean", .bool),
                 ("null", .null),
                 ("object", .object),
                 ("string", .string):
                true
            case let ("integer", .number(number)):
                number.rounded() == number
            case ("number", .number):
                true
            default:
                false
            }
        }

        private func resolve(_ ref: String) throws -> [String: JSONValue] {
            guard ref.hasPrefix("#/") else {
                throw ValidationSetupError.unsupportedReference(ref)
            }

            let parts = ref
                .dropFirst(2)
                .split(separator: "/")
                .map { String($0).replacingOccurrences(of: "~1", with: "/").replacingOccurrences(of: "~0", with: "~") }

            var current = root
            for part in parts {
                guard
                    let object = current.objectValue,
                    let next = object[part]
                else {
                    throw ValidationSetupError.missingReferencePart(part)
                }
                current = next
            }

            guard let resolved = current.objectValue else {
                throw ValidationSetupError.referenceIsNotObject(ref)
            }
            return resolved
        }
    }
}

private enum ValidationSetupError: Error, CustomStringConvertible {
    case missingReferencePart(String)
    case referenceIsNotObject(String)
    case rootSchemaIsNotObject
    case unsupportedReference(String)

    var description: String {
        switch self {
        case let .missingReferencePart(part):
            "missing reference part \(part)"
        case let .referenceIsNotObject(ref):
            "reference is not an object: \(ref)"
        case .rootSchemaIsNotObject:
            "root schema is not an object"
        case let .unsupportedReference(ref):
            "unsupported reference: \(ref)"
        }
    }
}
