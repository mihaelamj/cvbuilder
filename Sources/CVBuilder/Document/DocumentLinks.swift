import Foundation

/// Link groups that belong to a published CV page rather than to core resume
/// facts.
///
/// Use `profiles` for public profile destinations, `downloads` for files such
/// as a PDF resume, and `companyURLs` to link role headings without baking
/// site-specific logic into renderers.
public struct DocumentLinks: Codable, Equatable, Sendable {
    public let profiles: [Link]
    public let downloads: [Link]
    public let companyURLs: [String: String]

    public init(
        profiles: [Link] = [],
        downloads: [Link] = [],
        companyURLs: [String: String] = [:],
    ) {
        self.profiles = profiles
        self.downloads = downloads
        self.companyURLs = companyURLs
    }
}
