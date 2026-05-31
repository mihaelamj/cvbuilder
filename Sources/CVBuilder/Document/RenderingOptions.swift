import Foundation

/// Length and inclusion controls for rendering a `CVDocument`. All optional, so
/// an omitted block renders the full CV.
public struct RenderingOptions: Codable, Hashable {
    /// Most-recent companies shown in full; the rest become a condensed
    /// "Earlier experience" list. `nil` shows every company in full.
    public var recentCompanyCount: Int?
    /// Cap on description bullets per project. `nil` shows all bullets.
    public var maxBulletsPerProject: Int?

    public init(
        recentCompanyCount: Int? = nil,
        maxBulletsPerProject: Int? = nil
    ) {
        self.recentCompanyCount = recentCompanyCount
        self.maxBulletsPerProject = maxBulletsPerProject
    }
}
