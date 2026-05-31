import Foundation

/// A conference talk or speaking engagement. Part of a publishable `CVDocument`,
/// not the core `CV` resume model.
public struct SpeakingEngagement: Codable, Identifiable, Hashable {
    public let id: UUID
    public let event: String
    public let date: String
    public let role: String
    public let title: String
    public let location: String
    public let website: Link?
    public let recordingURL: URL?

    public init(
        id: UUID = UUID(),
        event: String,
        date: String,
        role: String,
        title: String,
        location: String,
        website: Link? = nil,
        recordingURL: URL? = nil
    ) {
        self.id = id
        self.event = event
        self.date = date
        self.role = role
        self.title = title
        self.location = location
        self.website = website
        self.recordingURL = recordingURL
    }

    // Synthesize `id` when absent so hand-authored JSON never needs a UUID.
    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        event = try c.decode(String.self, forKey: .event)
        date = try c.decode(String.self, forKey: .date)
        role = try c.decode(String.self, forKey: .role)
        title = try c.decode(String.self, forKey: .title)
        location = try c.decode(String.self, forKey: .location)
        website = try c.decodeIfPresent(Link.self, forKey: .website)
        recordingURL = try c.decodeIfPresent(URL.self, forKey: .recordingURL)
    }
}
