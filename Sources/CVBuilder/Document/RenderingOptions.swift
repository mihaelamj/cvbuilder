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

    private enum CodingKeys: String, CodingKey {
        case mode
        case recentCompanyCount
        case maxBulletsPerProject
        case nestProjectsUnderRoles
        case compactGroupedSkills
        case omitEmptySections
    }

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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        mode = try container.decode(
            RenderingMode.self,
            forKey: .mode,
            defaultIfMissing: .experiencedTechnical
        )
        recentCompanyCount = try container.decodeIfPresent(Int.self, forKey: .recentCompanyCount)
        maxBulletsPerProject = try container.decodeIfPresent(Int.self, forKey: .maxBulletsPerProject)
        nestProjectsUnderRoles = try container.decode(
            Bool.self,
            forKey: .nestProjectsUnderRoles,
            defaultIfMissing: true
        )
        compactGroupedSkills = try container.decode(
            Bool.self,
            forKey: .compactGroupedSkills,
            defaultIfMissing: true
        )
        omitEmptySections = try container.decode(
            Bool.self,
            forKey: .omitEmptySections,
            defaultIfMissing: true
        )
    }
}
