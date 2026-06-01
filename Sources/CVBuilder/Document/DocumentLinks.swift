import Foundation

/// Link groups that belong to a published CV page rather than to core resume
/// facts.
///
/// Use `profiles` for public profile destinations, `downloads` for files such
/// as a PDF resume, and `companyURLs` to link role headings without baking
/// site-specific logic into renderers.
public struct DocumentLinks: Codable, Equatable, Sendable {
    /// Public profile links rendered in the document `Links` section.
    public let profiles: [Link]
    /// Download links rendered in the document `Links` section.
    public let downloads: [Link]
    /// Company-name to URL mapping used to link matching work-experience headings.
    public let companyURLs: [String: String]

    private enum CodingKeys: String, CodingKey {
        case profiles
        case downloads
        case companyURLs
    }

    public init(
        profiles: [Link] = [],
        downloads: [Link] = [],
        companyURLs: [String: String] = [:],
    ) {
        self.profiles = profiles
        self.downloads = downloads
        self.companyURLs = companyURLs
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        profiles = try container.decode([Link].self, forKey: .profiles, defaultIfMissing: [])
        downloads = try container.decode([Link].self, forKey: .downloads, defaultIfMissing: [])
        companyURLs = try container.decode([String: String].self, forKey: .companyURLs, defaultIfMissing: [:])
    }
}
