import Foundation

public struct ProjectExperience: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let project: Project
    public let role: Role
    public let period: Period
    public let technicalFocus: TechnicalFocus?

    private enum CodingKeys: String, CodingKey {
        case id
        case project
        case role
        case period
        case technicalFocus
    }

    public init(
        id: UUID = UUID(),
        project: Project,
        role: Role,
        period: Period,
        technicalFocus: TechnicalFocus? = nil,
    ) {
        self.id = id
        self.project = project
        self.role = role
        self.period = period
        self.technicalFocus = technicalFocus
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id, defaultIfMissing: UUID())
        project = try container.decode(Project.self, forKey: .project)
        role = try container.decode(Role.self, forKey: .role)
        period = try container.decode(Period.self, forKey: .period)
        technicalFocus = try container.decodeIfPresent(TechnicalFocus.self, forKey: .technicalFocus)
    }

    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        project = try c.decode(Project.self, forKey: .project)
        role = try c.decode(Role.self, forKey: .role)
        period = try c.decode(Period.self, forKey: .period)
    }
}

public extension ProjectExperience {
    var company: Company {
        project.company
    }

    var descriptions: [String] {
        project.descriptions
    }

    var techs: [Tech] {
        project.techs
    }

    var name: String {
        project.name
    }

    var urls: [URL]? {
        project.urls
    }
}
