import Foundation

/// Rendering preferences for generated CV output.
///
/// Options describe document ordering and compaction choices only. They do not
/// carry scoring, inferred fit, ranking, or parser-specific tricks.
public struct RenderingOptions: Codable, Equatable, Sendable {
    public let mode: RenderingMode
    public let recentCompanyCount: Int?
    public let maxBulletsPerProject: Int?
    public let nestProjectsUnderRoles: Bool
    public let compactGroupedSkills: Bool
    public let omitEmptySections: Bool

    public init(
        mode: RenderingMode = .experiencedTechnical,
        recentCompanyCount: Int? = nil,
        maxBulletsPerProject: Int? = nil,
        nestProjectsUnderRoles: Bool = true,
        compactGroupedSkills: Bool = true,
        omitEmptySections: Bool = true,
    ) {
        self.mode = mode
        self.recentCompanyCount = recentCompanyCount
        self.maxBulletsPerProject = maxBulletsPerProject
        self.nestProjectsUnderRoles = nestProjectsUnderRoles
        self.compactGroupedSkills = compactGroupedSkills
        self.omitEmptySections = omitEmptySections
    }
}
