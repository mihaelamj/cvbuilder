import Foundation

public struct Company: Codable, Identifiable, Hashable {
    public let id: UUID
    public let name: String
    
    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }

    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try c.decode(String.self, forKey: .name)
    }
}
