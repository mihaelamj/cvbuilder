import Foundation

public struct WorkExperience: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let company: Company
    public let role: Role // Keep highest role for company-level summary
    public let period: Period
    public let projects: [ProjectExperience]
    public let isCurrent: Bool
    public let technicalFocus: TechnicalFocus?

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
