import Foundation

public struct ProjectExperience: Codable, Identifiable, Hashable {
    public let id: UUID
    public let project: Project
    public let role: Role
    public let period: Period

    public init(
        id: UUID = UUID(),
        project: Project,
        role: Role,
        period: Period
    ) {
        self.id = id
        self.project = project
        self.role = role
        self.period = period
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
