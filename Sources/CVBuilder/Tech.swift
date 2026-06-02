import Foundation

/*
 ```swift
     public static let swift = Tech(name: "Swift", category: .language)
     public static let swiftUI = Tech(name: "SwiftUI", category: .framework)
     public static let objc = Tech(name: "Objective-C", category: .language)
     public static let uiKit = Tech(name: "UIKit", category: .framework)
 ```
 */

public struct Tech: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID?
    public let name: String
    public let category: Category?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
    }

    public init(id: UUID? = nil, name: String, category: Category? = nil) {
        self.id = id
        self.name = name
        self.category = category
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeOmittable(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decodeIfPresent(Category.self, forKey: .category)
    }

    /// Identity is the semantic skill (`name` + `category`), not the synthesized
    /// `id`. Two skills naming the same technology in the same category are the
    /// same skill, so `Set`/grouping deduplicate by meaning rather than by a
    /// per-instance identifier that may have been omitted from the source.
    public static func == (lhs: Tech, rhs: Tech) -> Bool {
        lhs.name == rhs.name && lhs.category == rhs.category
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(category)
    }

    public enum Category: String, Codable, Sendable {
        case language
        case framework
        case tool
        case platform
        case concept
        case other
    }

    public static func techsGroupedByCategory(_ techs: [Tech]) -> [Category?: [Tech]] {
        Dictionary(grouping: techs, by: { $0.category })
    }

    /// Deduplicates by semantic identity (`name` + `category`) and returns a
    /// total, locale-independent ordering so skill lists are byte-stable across
    /// runs. The category tie-break keeps two same-named skills in distinct
    /// categories in a deterministic order.
    public static func deduplicatedAndSorted(_ techs: [Tech]) -> [Tech] {
        Array(Set(techs)).sorted { lhs, rhs in
            if lhs.name != rhs.name {
                return lhs.name < rhs.name
            }

            return (lhs.category?.rawValue ?? "") < (rhs.category?.rawValue ?? "")
        }
    }
}
