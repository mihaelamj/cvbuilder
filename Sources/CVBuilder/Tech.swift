import Foundation

// Replacing enum with struct for flexibility

public struct Tech: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let name: String
    public let category: Category?
    
    public init(id: UUID = UUID(), name: String, category: Category? = nil) {
        self.id = id
        self.name = name
        self.category = category
    }

    public enum Category: String, Codable, Sendable {
        case language
        case framework
        case tool
        case platform
        case concept
        case other
    }

    public static let swift = Tech(name: "Swift", category: .language)
    public static let swiftUI = Tech(name: "SwiftUI", category: .framework)
    public static let objc = Tech(name: "Objective-C", category: .language)
    public static let uiKit = Tech(name: "UIKit", category: .framework)
    
    public static func techsGroupedByCategory(_ techs: [Tech]) -> [Category?: [Tech]] {
        return Dictionary(grouping: techs, by: { $0.category })
    }
}
