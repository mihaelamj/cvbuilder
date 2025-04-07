import Foundation

public struct Company: Codable, Identifiable, Hashable {
    public let id: UUID
    public let name: String
    
    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
