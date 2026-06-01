import Foundation

/// A public, verifiable technical artifact that supports the CV.
///
/// Evidence is descriptive only. It carries summary, role, technologies, and a
/// link so renderers can show context without inventing scores or rankings.
public struct PublicEvidence: Codable, Equatable, Identifiable, Sendable {
    /// Stable identifier for normalized JSON. Missing IDs are synthesized.
    public let id: UUID
    /// Evidence heading text.
    public let title: String
    /// Evidence category rendered as a factual label.
    public let kind: PublicEvidenceKind
    /// Candidate role or relationship to the evidence.
    public let role: String
    /// Short factual summary rendered under the evidence heading.
    public let summary: String
    /// Evidence destination kept as source text until Markdown rendering.
    public let url: String
    /// Technologies rendered as a labelled list for this evidence item.
    public let technologies: [String]
    /// Optional display date rendered when present and non-empty.
    public let date: String?
    /// Optional period rendered when `date` is absent.
    public let period: Period?
    /// Supporting factual highlights rendered in source order.
    public let highlights: [String]
    /// Optional local technical context for this evidence item.
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

        id = try container.decode(UUID.self, forKey: .id, defaultIfMissing: UUID())
        title = try container.decode(String.self, forKey: .title)
        kind = try container.decode(PublicEvidenceKind.self, forKey: .kind)
        role = try container.decode(String.self, forKey: .role)
        summary = try container.decode(String.self, forKey: .summary)
        url = try container.decode(String.self, forKey: .url)
        technologies = try container.decode([String].self, forKey: .technologies, defaultIfMissing: [])
        date = try container.decodeIfPresent(String.self, forKey: .date)
        period = try container.decodeIfPresent(Period.self, forKey: .period)
        highlights = try container.decode([String].self, forKey: .highlights, defaultIfMissing: [])
        technicalFocus = try container.decodeIfPresent(TechnicalFocus.self, forKey: .technicalFocus)
    }
}
