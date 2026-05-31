import Foundation

public struct Company: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let name: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id, defaultIfMissing: UUID())
        name = try container.decode(String.self, forKey: .name)
    }
}
