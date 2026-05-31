import Foundation

public struct WorkExperience: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
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
        id: UUID = UUID(),
        company: Company,
        role: Role,
        period: Period,
        projects: [ProjectExperience],
        isCurrent: Bool = false,
        technicalFocus: TechnicalFocus? = nil
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

        id = try container.decode(UUID.self, forKey: .id, defaultIfMissing: UUID())
        company = try container.decode(Company.self, forKey: .company)
        role = try container.decode(Role.self, forKey: .role)
        period = try container.decode(Period.self, forKey: .period)
        projects = try container.decode([ProjectExperience].self, forKey: .projects, defaultIfMissing: [])
        isCurrent = try container.decode(Bool.self, forKey: .isCurrent, defaultIfMissing: false)
        technicalFocus = try container.decodeIfPresent(TechnicalFocus.self, forKey: .technicalFocus)
    }

    public var formattedDateRange: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        let startDate = Calendar.current.date(from: DateComponents(year: period.start.year, month: period.start.month))!
        let startString = dateFormatter.string(from: startDate)
        if isCurrent {
            return "\(startString) - Present"
        }
        let endDate = Calendar.current.date(from: DateComponents(year: period.end.year, month: period.end.month))!
        return "\(startString) - \(dateFormatter.string(from: endDate))"
    }
}
