import Foundation

/// Rendering preferences for generated CV output.
///
/// Options describe document ordering and compaction choices only. They do not
/// carry scoring, inferred fit, ranking, or parser-specific tricks.
public struct RenderingOptions: Codable, Equatable, Sendable {
    /// Static-site-generator front matter profile.
    public let frontMatterProfile: FrontMatterProfile
    /// High-level section ordering strategy.
    public let mode: RenderingMode
    /// Output language for section labels, field labels, and month names.
    ///
    /// Defaults to `.english`, which reproduces the original literals exactly.
    /// Rendering never depends on the host locale, so output stays deterministic.
    public let locale: RenderingLocale
    /// Maximum number of work-experience entries to render. Non-positive values mean unlimited.
    public let recentCompanyCount: Int?
    /// Explicit ordered work-experience IDs to render. Empty values render all work entries before other limits.
    public let selectedExperienceIDs: [UUID]
    /// Maximum number of project description paragraphs to render. Non-positive values mean unlimited.
    public let maxBulletsPerProject: Int?
    /// Whether projects render under each role instead of in a standalone `Projects` section.
    public let nestProjectsUnderRoles: Bool
    /// Whether skills render grouped by category instead of one skill per line.
    public let compactGroupedSkills: Bool
    /// Whether empty optional sections are omitted from Markdown output.
    ///
    /// When `false`, the renderer emits empty optional section headings to make
    /// the intended document skeleton explicit.
    public let omitEmptySections: Bool

    private enum CodingKeys: String, CodingKey {
        case frontMatterProfile
        case mode
        case locale
        case recentCompanyCount
        case selectedExperienceIDs
        case maxBulletsPerProject
        case nestProjectsUnderRoles
        case compactGroupedSkills
        case omitEmptySections
    }

    public init(
        frontMatterProfile: FrontMatterProfile = .generic,
        mode: RenderingMode = .experiencedTechnical,
        locale: RenderingLocale = .english,
        recentCompanyCount: Int? = nil,
        selectedExperienceIDs: [UUID] = [],
        maxBulletsPerProject: Int? = nil,
        nestProjectsUnderRoles: Bool = true,
        compactGroupedSkills: Bool = true,
        omitEmptySections: Bool = true,
    ) {
        self.frontMatterProfile = frontMatterProfile
        self.mode = mode
        self.locale = locale
        self.recentCompanyCount = recentCompanyCount
        self.selectedExperienceIDs = selectedExperienceIDs
        self.maxBulletsPerProject = maxBulletsPerProject
        self.nestProjectsUnderRoles = nestProjectsUnderRoles
        self.compactGroupedSkills = compactGroupedSkills
        self.omitEmptySections = omitEmptySections
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        frontMatterProfile = try container.decode(
            FrontMatterProfile.self,
            forKey: .frontMatterProfile,
            defaultIfMissing: .generic,
        )
        mode = try container.decode(
            RenderingMode.self,
            forKey: .mode,
            defaultIfMissing: .experiencedTechnical,
        )
        locale = try container.decode(
            RenderingLocale.self,
            forKey: .locale,
            defaultIfMissing: .english,
        )
        recentCompanyCount = try container.decodeIfPresent(Int.self, forKey: .recentCompanyCount)
        selectedExperienceIDs = try container.decode(
            [UUID].self,
            forKey: .selectedExperienceIDs,
            defaultIfMissing: [],
        )
        maxBulletsPerProject = try container.decodeIfPresent(Int.self, forKey: .maxBulletsPerProject)
        nestProjectsUnderRoles = try container.decode(
            Bool.self,
            forKey: .nestProjectsUnderRoles,
            defaultIfMissing: true,
        )
        compactGroupedSkills = try container.decode(
            Bool.self,
            forKey: .compactGroupedSkills,
            defaultIfMissing: true,
        )
        omitEmptySections = try container.decode(
            Bool.self,
            forKey: .omitEmptySections,
            defaultIfMissing: true,
        )
    }
}
