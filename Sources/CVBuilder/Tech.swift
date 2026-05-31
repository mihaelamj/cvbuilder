import Foundation

/**
 ```swift
     public static let swift = Tech(name: "Swift", category: .language)
     public static let swiftUI = Tech(name: "SwiftUI", category: .framework)
     public static let objc = Tech(name: "Objective-C", category: .language)
     public static let uiKit = Tech(name: "UIKit", category: .framework)
 ```
 */

public struct Tech: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let name: String
    public let category: Category?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
    }

    public init(id: UUID = UUID(), name: String, category: Category? = nil) {
        self.id = id
        self.name = name
        self.category = category
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(UUID.self, forKey: .id, default: UUID())
        name = try container.decode(String.self, forKey: .name)
        category = try container.decodeIfPresent(Category.self, forKey: .category)
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
        return Dictionary(grouping: techs, by: { $0.category })
    }
}
