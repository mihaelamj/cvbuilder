import Foundation

/// The per-profile front-matter key contract: ordering plus which keys coerce to
/// a boolean or an array. Coercion is profile-specific rather than global, so a
/// profile only folds the keys it actually declares (Hugo and Toucan own
/// `draft`; Jekyll owns `published`), instead of mistyping a key a profile does
/// not define.
private struct FrontMatterCoercion {
    let preferredKeys: [String]
    let booleanKeys: Set<String>
    let arrayKeys: Set<String>
}

extension Rendering.MarkdownDocumentRenderer {
    func frontMatterBlock(_ frontMatter: [String: String], profile: FrontMatterProfile) -> [String] {
        switch profile {
        case .generic:
            // The generic profile coerces nothing: every value is a quoted
            // single-line scalar. SSG profiles below fold their declared
            // boolean and array keys, so a value such as `draft` or `tags` is
            // typed under a profile but a string under generic by design.
            genericYAMLFrontMatterBlock(frontMatter)
        case .toucan:
            yamlFrontMatterBlock(frontMatter, coercion: FrontMatterCoercion(
                preferredKeys: ["title", "description", "date", "tags", "draft", "slug", "layout"],
                booleanKeys: ["draft"],
                arrayKeys: ["tags"],
            ))
        case .hugo:
            tomlFrontMatterBlock(frontMatter, coercion: FrontMatterCoercion(
                preferredKeys: ["title", "description", "date", "draft", "slug", "tags", "categories", "type", "layout"],
                booleanKeys: ["draft"],
                arrayKeys: ["tags", "categories"],
            ))
        case .jekyll:
            yamlFrontMatterBlock(frontMatter, coercion: FrontMatterCoercion(
                preferredKeys: ["layout", "title", "permalink", "date", "tags", "categories", "published", "slug"],
                booleanKeys: ["published"],
                arrayKeys: ["tags", "categories"],
            ))
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

    private func yamlFrontMatterBlock(_ frontMatter: [String: String], coercion: FrontMatterCoercion) -> [String] {
        var lines = ["---"]
        for key in orderedFrontMatterKeys(frontMatter, preferredKeys: coercion.preferredKeys) {
            lines.append(contentsOf: yamlFrontMatterLines(key: key, value: frontMatter[key] ?? "", coercion: coercion))
        }
        lines.append("---")
        return lines
    }

    private func tomlFrontMatterBlock(_ frontMatter: [String: String], coercion: FrontMatterCoercion) -> [String] {
        var lines = ["+++"]
        for key in orderedFrontMatterKeys(frontMatter, preferredKeys: coercion.preferredKeys) {
            lines.append(tomlFrontMatterLine(key: key, value: frontMatter[key] ?? "", coercion: coercion))
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

    private func yamlFrontMatterLines(key: String, value: String, coercion: FrontMatterCoercion) -> [String] {
        let yamlKey = escapedFrontMatterKey(key)

        if coercion.booleanKeys.contains(key), let bool = frontMatterBool(value) {
            return ["\(yamlKey): \(bool ? "true" : "false")"]
        }

        if coercion.arrayKeys.contains(key) {
            let values = frontMatterArray(value)
            guard !values.isEmpty else {
                return ["\(yamlKey): []"]
            }

            return ["\(yamlKey):"] + values.map { "  - \(escapedFrontMatterScalar($0))" }
        }

        return ["\(yamlKey): \(escapedFrontMatterScalar(value))"]
    }

    private func tomlFrontMatterLine(key: String, value: String, coercion: FrontMatterCoercion) -> String {
        let tomlKey = escapedTOMLKey(key)

        if coercion.booleanKeys.contains(key), let bool = frontMatterBool(value) {
            return "\(tomlKey) = \(bool ? "true" : "false")"
        }

        if coercion.arrayKeys.contains(key) {
            let renderedValues = frontMatterArray(value)
                .map(escapedFrontMatterScalar)
                .joined(separator: ", ")
            return "\(tomlKey) = [\(renderedValues)]"
        }

        return "\(tomlKey) = \(escapedFrontMatterScalar(value))"
    }

    /// Recognizes the common static-site-generator boolean spellings
    /// (case-insensitively): `true`/`false`, `yes`/`no`, `1`/`0`, `on`/`off`.
    /// Any other value returns `nil`, so the caller emits it as a quoted scalar
    /// rather than guessing a boolean.
    private func frontMatterBool(_ value: String) -> Bool? {
        switch value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "true", "yes", "1", "on":
            true
        case "false", "no", "0", "off":
            false
        default:
            nil
        }
    }

    /// Splits a comma-separated value into trimmed, non-empty elements. An empty
    /// or separator-only value yields an empty array so an array key renders as
    /// an empty sequence rather than a string scalar.
    private func frontMatterArray(_ value: String) -> [String] {
        value
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
