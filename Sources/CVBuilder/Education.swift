import Foundation

public struct Education: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID?
    public let institution: String
    public let degree: String
    public let field: String
    public let period: Period

    private enum CodingKeys: String, CodingKey {
        case id
        case institution
        case degree
        case field
        case period
    }

    public init(
        id: UUID? = nil,
        institution: String,
        degree: String,
        field: String,
        period: Period,
    ) {
        self.id = id
        self.institution = institution
        self.degree = degree
        self.field = field
        self.period = period
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeOmittable(UUID.self, forKey: .id)
        institution = try container.decode(String.self, forKey: .institution)
        degree = try container.decode(String.self, forKey: .degree)
        field = try container.decode(String.self, forKey: .field)
        period = try container.decode(Period.self, forKey: .period)
    }
}
