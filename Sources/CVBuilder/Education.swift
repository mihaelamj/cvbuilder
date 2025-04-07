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
}
