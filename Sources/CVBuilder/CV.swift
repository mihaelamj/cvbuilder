import Foundation

public struct CV: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID?
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
        id: UUID? = nil,
        name: String,
        title: String,
        summary: String,
        contactInfo: ContactInfo,
        experience: [WorkExperience],
        education: [Education],
        skills: [Tech],
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

        id = try container.decodeOmittable(UUID.self, forKey: .id)
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
        projects: [Project],
    ) -> CV {
        // Group by company
        let grouped = Dictionary(grouping: projects, by: \.company)

        // Create WorkExperience entries
        let experiences: [WorkExperience] = grouped.compactMap { company, companyProjects in
            let projectExperiences = companyProjects.map {
                ProjectExperience(project: $0, role: $0.role, period: $0.period)
            }

            guard let firstProjectExperience = projectExperiences.first else {
                return nil
            }

            // Span the company period across the present project dates; an
            // absent bound stays absent rather than being fabricated.
            let start = projectExperiences.compactMap(\.period.start).min()
            let end = projectExperiences.compactMap(\.period.end).max()
            let period = Period(start: start, end: end)

            let highestRole = projectExperiences.map(\.role).max(by: { rank($0) < rank($1) }) ?? firstProjectExperience.role
            let isCurrent = companyProjects.contains { $0.isCurrent }

            return WorkExperience(
                company: company,
                role: highestRole,
                period: period,
                projects: projectExperiences.sorted {
                    Period.SimpleDate.isAscending($0.period.start, before: $1.period.start)
                },
                isCurrent: isCurrent,
            )
        }
        // Most recent first; an absent end (ongoing) sorts ahead of dated ends.
        .sorted { Period.SimpleDate.isAscending($1.period.end, before: $0.period.end) }

        let uniqueSkills = Tech.deduplicatedAndSorted(projects.flatMap(\.techs))

        return CV(
            name: name,
            title: title,
            summary: summary,
            contactInfo: contactInfo,
            experience: experiences,
            education: education,
            skills: uniqueSkills,
        )
    }

    /// Optional helper if you still want to print or debug flat project info
    public func allProjectExperiences() -> [ProjectExperience] {
        experience.flatMap(\.projects)
    }

    public func allUniqueSkills() -> [Tech] {
        Tech.deduplicatedAndSorted(experience.flatMap { $0.projects.flatMap(\.project.techs) })
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
        projects: [Project],
    ) -> CV {
        CV.createFromProjects(
            name: name,
            title: title,
            summary: summary,
            contactInfo: contactInfo,
            education: education,
            projects: projects,
        )
    }
}
