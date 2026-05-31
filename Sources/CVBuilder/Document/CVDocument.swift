import Foundation

/// A publishable CV page: the core `CV` resume plus the presentation sections a
/// website shows (speaking, open source, extra links) and SSG-agnostic front
/// matter. Decodes from a single JSON file so a CV page can be generated with
/// `cvbuilder --data cv.json --out cv/index.md`, no per-site Swift.
///
/// `CV` stays pure (it is the resume); `CVDocument` is "a CV as a published
/// page". Only `cv` is required; every other section defaults to empty.
public struct CVDocument: Codable {
    /// Front matter emitted verbatim as the leading YAML block, so the same file
    /// works for any static site generator (Toucan, Tiledown, Jekyll, ...).
    public var frontMatter: [String: String]
    public var cv: CV
    public var links: DocumentLinks
    public var speaking: [SpeakingEngagement]
    public var openSource: [OpenSourceProject]
    public var rendering: RenderingOptions

    public init(
        frontMatter: [String: String] = [:],
        cv: CV,
        links: DocumentLinks = .init(),
        speaking: [SpeakingEngagement] = [],
        openSource: [OpenSourceProject] = [],
        rendering: RenderingOptions = .init()
    ) {
        self.frontMatter = frontMatter
        self.cv = cv
        self.links = links
        self.speaking = speaking
        self.openSource = openSource
        self.rendering = rendering
    }

    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        frontMatter = try c.decodeIfPresent([String: String].self, forKey: .frontMatter) ?? [:]
        cv = try c.decode(CV.self, forKey: .cv)
        links = try c.decodeIfPresent(DocumentLinks.self, forKey: .links) ?? .init()
        speaking = try c.decodeIfPresent([SpeakingEngagement].self, forKey: .speaking) ?? []
        openSource = try c.decodeIfPresent([OpenSourceProject].self, forKey: .openSource) ?? []
        rendering = try c.decodeIfPresent(RenderingOptions.self, forKey: .rendering) ?? .init()
    }

    /// Decodes a document from JSON `Data`.
    public static func decode(from data: Data) throws -> CVDocument {
        try JSONDecoder().decode(CVDocument.self, from: data)
    }
}
