import Foundation

public struct Company: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID?
    public let name: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    public init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeOmittable(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }

    /// Identity is the employer `name`, not the synthesized `id`. Grouping
    /// projects by company (see `CV.createFromProjects`) must merge every
    /// project at the same employer into one experience entry, even when each
    /// `Company` value was constructed separately and carries a distinct (or
    /// omitted) `id`.
    public static func == (lhs: Company, rhs: Company) -> Bool {
        lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
