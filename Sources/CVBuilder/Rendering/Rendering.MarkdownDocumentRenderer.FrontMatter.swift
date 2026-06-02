import Foundation

extension Rendering.MarkdownDocumentRenderer {
    func frontMatterBlock(_ frontMatter: [String: String], profile: FrontMatterProfile) -> [String] {
        switch profile {
        case .generic:
            genericYAMLFrontMatterBlock(frontMatter)
        case .toucan:
            yamlFrontMatterBlock(
                frontMatter,
                preferredKeys: ["title", "description", "date", "tags", "draft", "slug", "layout"],
            )
        case .hugo:
            tomlFrontMatterBlock(
                frontMatter,
                preferredKeys: ["title", "description", "date", "draft", "slug", "tags", "categories", "type", "layout"],
            )
        case .jekyll:
            yamlFrontMatterBlock(
                frontMatter,
                preferredKeys: ["layout", "title", "permalink", "date", "tags", "categories", "published", "slug"],
            )
        }
    }

    private func genericYAMLFrontMatterBlock(_ frontMatter: [String: String]) -> [String] {
        var lines = ["---"]
        for key in frontMatter.keys.sorted() {
            lines.append("\(escapedFrontMatterKey(key)): \(escapedFrontMatterScalar(frontMatter[key] ?? ""))")
        }
        lines.append("---")
        return lines
    }

    private func yamlFrontMatterBlock(_ frontMatter: [String: String], preferredKeys: [String]) -> [String] {
        var lines = ["---"]
        for key in orderedFrontMatterKeys(frontMatter, preferredKeys: preferredKeys) {
            lines.append(contentsOf: yamlFrontMatterLines(key: key, value: frontMatter[key] ?? ""))
        }
        lines.append("---")
        return lines
    }

    private func tomlFrontMatterBlock(_ frontMatter: [String: String], preferredKeys: [String]) -> [String] {
        var lines = ["+++"]
        for key in orderedFrontMatterKeys(frontMatter, preferredKeys: preferredKeys) {
            lines.append(tomlFrontMatterLine(key: key, value: frontMatter[key] ?? ""))
        }
        lines.append("+++")
        return lines
    }

    private func orderedFrontMatterKeys(_ frontMatter: [String: String], preferredKeys: [String]) -> [String] {
        let availableKeys = Set(frontMatter.keys)
        let preferred = preferredKeys.filter { availableKeys.contains($0) }
        let remaining = frontMatter.keys
            .filter { !preferredKeys.contains($0) }
            .sorted()
        return preferred + remaining
    }

    private func yamlFrontMatterLines(key: String, value: String) -> [String] {
        let yamlKey = escapedFrontMatterKey(key)

        if let bool = frontMatterBool(key: key, value: value) {
            return ["\(yamlKey): \(bool ? "true" : "false")"]
        }

        if let values = frontMatterArray(key: key, value: value) {
            guard !values.isEmpty else {
                return ["\(yamlKey): []"]
            }

            return ["\(yamlKey):"] + values.map { "  - \(escapedFrontMatterScalar($0))" }
        }

        return ["\(yamlKey): \(escapedFrontMatterScalar(value))"]
    }

    private func tomlFrontMatterLine(key: String, value: String) -> String {
        let tomlKey = escapedTOMLKey(key)

        if let bool = frontMatterBool(key: key, value: value) {
            return "\(tomlKey) = \(bool ? "true" : "false")"
        }

        if let values = frontMatterArray(key: key, value: value) {
            let renderedValues = values
                .map(escapedFrontMatterScalar)
                .joined(separator: ", ")
            return "\(tomlKey) = [\(renderedValues)]"
        }

        return "\(tomlKey) = \(escapedFrontMatterScalar(value))"
    }

    private func frontMatterBool(key: String, value: String) -> Bool? {
        guard ["draft", "published"].contains(key) else {
            return nil
        }

        switch value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "true":
            return true
        case "false":
            return false
        default:
            return nil
        }
    }

    private func frontMatterArray(key: String, value: String) -> [String]? {
        guard ["tags", "categories"].contains(key) else {
            return nil
        }

        // Always return an array for these keys, never nil. An empty or
        // separator-only value yields an empty array so the field renders as an
        // empty sequence rather than falling through to a string scalar (which
        // would leak the raw separator and give the key a non-uniform type).
        return value
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private func escapedTOMLKey(_ key: String) -> String {
        guard !key.isEmpty,
              key.unicodeScalars.allSatisfy(isBareTOMLKeyScalar)
        else {
            return escapedFrontMatterScalar(key)
        }

        return key
    }

    private func isBareTOMLKeyScalar(_ scalar: UnicodeScalar) -> Bool {
        let value = scalar.value
        return value == 45
            || value == 95
            || (48 ... 57).contains(value)
            || (65 ... 90).contains(value)
            || (97 ... 122).contains(value)
    }
}
