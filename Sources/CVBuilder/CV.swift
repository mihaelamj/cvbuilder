import Foundation

public struct CV: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let name: String
    public let title: String
    public let summary: String
    public let contactInfo: ContactInfo
    public let experience: [WorkExperience]
    public let education: [Education]
    public let skills: [Tech]

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case summary
        case contactInfo
        case experience
        case education
        case skills
    }

    public init(
        id: UUID = UUID(),
        name: String,
        title: String,
        summary: String,
        contactInfo: ContactInfo,
        experience: [WorkExperience],
        education: [Education],
        skills: [Tech]
    ) {
        self.id = id
        self.name = name
        self.title = title
        self.summary = summary
        self.contactInfo = contactInfo
        self.experience = experience
        self.education = education
        self.skills = skills
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id, defaultIfMissing: UUID())
        name = try container.decode(String.self, forKey: .name)
        title = try container.decode(String.self, forKey: .title)
        summary = try container.decode(String.self, forKey: .summary)
        contactInfo = try container.decode(ContactInfo.self, forKey: .contactInfo)
        experience = try container.decode([WorkExperience].self, forKey: .experience, defaultIfMissing: [])
        education = try container.decode([Education].self, forKey: .education, defaultIfMissing: [])
        skills = try container.decode([Tech].self, forKey: .skills, defaultIfMissing: [])
    }

    public static func createFromProjects(
        name: String,
        title: String,
        summary: String,
        contactInfo: ContactInfo,
        education: [Education],
        projects: [Project]
    ) -> CV {
        // Group by company
        let grouped = Dictionary(grouping: projects, by: \.company)

        // Create WorkExperience entries
        let experiences: [WorkExperience] = grouped.map { company, companyProjects in
            let projectExperiences = companyProjects.map {
                ProjectExperience(project: $0, role: $0.role, period: $0.period)
            }

            let start = projectExperiences.map { $0.period.start }.min()!
            let end = projectExperiences.map { $0.period.end }.max()!
            let period = Period(start: start, end: end)

            let highestRole = projectExperiences.map(\.role).max(by: { rank($0) < rank($1) })!
            let isCurrent = companyProjects.contains { $0.isCurrent }

            return WorkExperience(
                company: company,
                role: highestRole,
                period: period,
                projects: projectExperiences.sorted { $0.period.start < $1.period.start },
                isCurrent: isCurrent
            )
        }
        .sorted { $0.period.end > $1.period.end } // most recent first

        let uniqueSkills = Set(projects.flatMap(\.techs)).sorted { $0.name < $1.name }

        return CV(
            name: name,
            title: title,
            summary: summary,
            contactInfo: contactInfo,
            experience: experiences,
            education: education,
            skills: uniqueSkills
        )
    }

    // Optional helper if you still want to print or debug flat project info
    public func allProjectExperiences() -> [ProjectExperience] {
        experience.flatMap(\.projects)
    }

    public func allUniqueSkills() -> [Tech] {
        Set(experience.flatMap { $0.projects.flatMap { $0.project.techs } }).sorted { $0.name < $1.name }
    }
}

public extension CV {
    /// Generic CV creation function that can be used by anyone
    static func create(
        name: String,
        title: String,
        summary: String,
        contactInfo: ContactInfo,
        education: [Education],
        projects: [Project]
    ) -> CV {
        return CV.createFromProjects(
            name: name,
            title: title,
            summary: summary,
            contactInfo: contactInfo,
            education: education,
            projects: projects
        )
    }
}
