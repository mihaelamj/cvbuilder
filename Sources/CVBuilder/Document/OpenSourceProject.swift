import Foundation

/// An open-source project listed on a CV page. Part of a publishable
/// `CVDocument`, not the core `CV` resume model.
public struct OpenSourceProject: Codable, Identifiable, Hashable {
    public let id: UUID
    public let name: String
    public let description: String
    public let url: URL
    public let techs: [String]

    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        url: URL,
        techs: [String] = []
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.techs = techs
    }

    // Synthesize `id` when absent so hand-authored JSON never needs a UUID.
    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try c.decode(String.self, forKey: .name)
        description = try c.decode(String.self, forKey: .description)
        url = try c.decode(URL.self, forKey: .url)
        techs = try c.decodeIfPresent([String].self, forKey: .techs) ?? []
    }
}
