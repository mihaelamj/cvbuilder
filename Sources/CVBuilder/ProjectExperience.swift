import Foundation

public struct ProjectExperience: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let project: Project
    public let role: Role
    public let period: Period
    public let technicalFocus: TechnicalFocus?

    public init(
        id: UUID = UUID(),
        project: Project,
        role: Role,
        period: Period,
        technicalFocus: TechnicalFocus? = nil
    ) {
        self.id = id
        self.project = project
        self.role = role
        self.period = period
        self.technicalFocus = technicalFocus
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
