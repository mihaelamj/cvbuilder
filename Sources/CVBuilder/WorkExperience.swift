import Foundation

public struct WorkExperience: Codable, Identifiable, Hashable {
    public let id: UUID
    public let company: Company
    public let role: Role // Keep highest role for company-level summary
    public let period: Period
    public let projects: [ProjectExperience]
    
    public init(
        id: UUID = UUID(),
        company: Company,
        role: Role,
        period: Period,
        projects: [ProjectExperience]
    ) {
        self.id = id
        self.company = company
        self.role = role
        self.period = period
        self.projects = projects
    }

    public var formattedDateRange: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        let startDate = Calendar.current.date(from: DateComponents(year: period.start.year, month: period.start.month))!
        let endDate = Calendar.current.date(from: DateComponents(year: period.end.year, month: period.end.month))!
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
}
