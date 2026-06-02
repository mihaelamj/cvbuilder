import Foundation

/// Contact details for a CV: email, phone, location, and optional LinkedIn,
/// GitHub, and website URLs. Renderers show these as factual contact lines and
/// links; the optional URLs may be relative.
public struct ContactInfo: Codable, Hashable, Sendable {
    public let email: String
    public let phone: String
    public let linkedIn: URL?
    public let github: URL?
    public let website: URL?
    public let location: String

    public init(
        email: String,
        phone: String,
        linkedIn: URL? = nil,
        github: URL? = nil,
        website: URL? = nil,
        location: String,
    ) {
        self.email = email
        self.phone = phone
        self.linkedIn = linkedIn
        self.github = github
        self.website = website
        self.location = location
    }
}
