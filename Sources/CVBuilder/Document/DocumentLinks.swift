import Foundation

/// Presentation links a CV page shows beyond the core `ContactInfo`: a social
/// handle, a downloadable resume, and per-company website URLs.
public struct DocumentLinks: Codable, Hashable {
    public var twitter: URL?
    /// Path or URL to a downloadable resume (e.g. `/assets/cv.pdf`). A site-root
    /// path is common, so this is a `String`, not a `URL`.
    public var resumePDF: String?
    /// Company display name to its website URL, used to link experience headings.
    public var companyURLs: [String: URL]

    public init(
        twitter: URL? = nil,
        resumePDF: String? = nil,
        companyURLs: [String: URL] = [:]
    ) {
        self.twitter = twitter
        self.resumePDF = resumePDF
        self.companyURLs = companyURLs
    }

    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        twitter = try c.decodeIfPresent(URL.self, forKey: .twitter)
        resumePDF = try c.decodeIfPresent(String.self, forKey: .resumePDF)
        companyURLs = try c.decodeIfPresent([String: URL].self, forKey: .companyURLs) ?? [:]
    }
}
