import Foundation

public struct Education: Codable, Identifiable, Hashable {
    public let id: UUID
    public let institution: String
    public let degree: String
    public let field: String
    public let period: Period
    
    public init(
        id: UUID = UUID(),
        institution: String,
        degree: String,
        field: String,
        period: Period
    ) {
        self.id = id
        self.institution = institution
        self.degree = degree
        self.field = field
        self.period = period
    }

    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        institution = try c.decode(String.self, forKey: .institution)
        degree = try c.decode(String.self, forKey: .degree)
        field = try c.decode(String.self, forKey: .field)
        period = try c.decode(Period.self, forKey: .period)
    }
}
