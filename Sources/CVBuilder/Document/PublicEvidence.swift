import Foundation

/// A public, verifiable technical artifact that supports the CV.
///
/// Evidence is descriptive only. It carries summary, role, technologies, and a
/// link so renderers can show context without inventing scores or rankings.
public struct PublicEvidence: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let kind: PublicEvidenceKind
    public let role: String
    public let summary: String
    public let url: String
    public let technologies: [String]
    public let date: String?
    public let period: Period?
    public let highlights: [String]
    public let technicalFocus: TechnicalFocus?

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case kind
        case role
        case summary
        case url
        case technologies
        case date
        case period
        case highlights
        case technicalFocus
    }

    public init(
        id: UUID = UUID(),
        title: String,
        kind: PublicEvidenceKind,
        role: String,
        summary: String,
        url: String,
        technologies: [String] = [],
        date: String? = nil,
        period: Period? = nil,
        highlights: [String] = [],
        technicalFocus: TechnicalFocus? = nil,
    ) {
        self.id = id
        self.title = title
        self.kind = kind
        self.role = role
        self.summary = summary
        self.url = url
        self.technologies = technologies
        self.date = date
        self.period = period
        self.highlights = highlights
        self.technicalFocus = technicalFocus
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(UUID.self, forKey: .id, default: UUID())
        title = try container.decode(String.self, forKey: .title)
        kind = try container.decode(PublicEvidenceKind.self, forKey: .kind)
        role = try container.decode(String.self, forKey: .role)
        summary = try container.decode(String.self, forKey: .summary)
        url = try container.decode(String.self, forKey: .url)
        technologies = try container.decodeIfPresent([String].self, forKey: .technologies, default: [])
        date = try container.decodeIfPresent(String.self, forKey: .date)
        period = try container.decodeIfPresent(Period.self, forKey: .period)
        highlights = try container.decodeIfPresent([String].self, forKey: .highlights, default: [])
        technicalFocus = try container.decodeIfPresent(TechnicalFocus.self, forKey: .technicalFocus)
    }
}
