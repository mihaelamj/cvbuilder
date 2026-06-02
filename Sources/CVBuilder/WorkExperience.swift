import Foundation

public struct WorkExperience: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID?
    public let company: Company
    public let role: Role // Keep highest role for company-level summary
    public let period: Period
    public let projects: [ProjectExperience]
    public let isCurrent: Bool
    public let technicalFocus: TechnicalFocus?

    private enum CodingKeys: String, CodingKey {
        case id
        case company
        case role
        case period
        case projects
        case isCurrent
        case technicalFocus
    }

    public init(
        id: UUID? = nil,
        company: Company,
        role: Role,
        period: Period,
        projects: [ProjectExperience],
        isCurrent: Bool = false,
        technicalFocus: TechnicalFocus? = nil,
    ) {
        self.id = id
        self.company = company
        self.role = role
        self.period = period
        self.projects = projects
        self.isCurrent = isCurrent
        self.technicalFocus = technicalFocus
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeOmittable(UUID.self, forKey: .id)
        company = try container.decode(Company.self, forKey: .company)
        role = try container.decode(Role.self, forKey: .role)
        period = try container.decode(Period.self, forKey: .period)
        projects = try container.decode([ProjectExperience].self, forKey: .projects, defaultIfMissing: [])
        isCurrent = try container.decode(Bool.self, forKey: .isCurrent, defaultIfMissing: false)
        technicalFocus = try container.decodeIfPresent(TechnicalFocus.self, forKey: .technicalFocus)
    }

    /// Renders the period for the deprecated `CVRendering` string/console
    /// renderers, which have no locale. It is intentionally English-only
    /// (English month abbreviations and the literal `Present`). The canonical,
    /// localized formatting lives in `Rendering.MarkdownDocumentRenderer`; use
    /// `CVDocument` for locale-aware output.
    public var formattedDateRange: String {
        let startString = period.start.map(Self.format)
        if isCurrent {
            guard let startString else {
                return "Present"
            }

            return "\(startString) - Present"
        }

        switch (startString, period.end.map(Self.format)) {
        case let (start?, end?):
            return period.start == period.end ? start : "\(start) - \(end)"
        case let (start?, nil):
            return start
        case let (nil, end?):
            return end
        case (nil, nil):
            return ""
        }
    }

    private static func format(_ date: Period.SimpleDate) -> String {
        let monthNames = [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec",
        ]

        guard (1 ... monthNames.count).contains(date.month) else {
            return "\(date.year)"
        }

        return "\(monthNames[date.month - 1]) \(date.year)"
    }
}
