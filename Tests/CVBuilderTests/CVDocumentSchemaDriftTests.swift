@testable import CVBuilder
import Foundation
import Testing

@Suite("CVDocument Schema drift")
struct CVDocumentSchemaDriftTests {
    @Test("checked-in examples and fixtures validate against the JSON Schema", arguments: DocumentFixture.allCases)
    func fixturesValidateAgainstSchema(fixture: DocumentFixture) throws {
        let validator = try makeValidator()
        let document = try loadJSON(fixture.path)
        let errors = validator.validate(document)

        if !errors.isEmpty {
            Issue.record("Schema drift in \(fixture.path):\n\(errors.prefix(10).joined(separator: "\n"))")
        }
        #expect(errors.isEmpty)
    }

    @Test("schema drift check rejects disconnected fixture shape")
    func schemaDriftCheckRejectsDisconnectedFixtureShape() throws {
        let validator = try makeValidator()
        let document = try loadJSON(DocumentFixture.demoCV.path)
        let brokenDocument = try removingRequiredCVName(from: document)
        let errors = validator.validate(brokenDocument)

        #expect(errors.contains { $0.contains("$.cv.name") && $0.contains("required") })
    }

    private func makeValidator() throws -> SchemaSubsetValidator {
        try SchemaSubsetValidator(schema: loadJSON("Schemas/cvdocument.schema.json"))
    }

    private func loadJSON(_ relativePath: String) throws -> JSONValue {
        let data = try Data(contentsOf: repositoryURL(relativePath))
        return try JSONDecoder().decode(JSONValue.self, from: data)
    }

    private func repositoryURL(_ relativePath: String) -> URL {
        URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(relativePath)
    }

    private func removingRequiredCVName(from document: JSONValue) throws -> JSONValue {
        guard
            case var .object(root) = document,
            case var .object(cv) = root["cv"]
        else {
            Issue.record("Expected fixture root to contain a cv object")
            return document
        }

        cv.removeValue(forKey: "name")
        root["cv"] = .object(cv)
        return .object(root)
    }
}

private struct SchemaSubsetValidator {
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
}

private enum JSONValue: Decodable, Equatable {
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
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON value")
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
