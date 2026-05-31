import Foundation

/// A publishable technical CV document.
///
/// `CVDocument` keeps `CV` as the canonical resume data and adds publishing
/// metadata that a generated Markdown page needs: static-site front matter,
/// links, public evidence, and rendering preferences. It does not know about a
/// specific static site generator or output format.
public struct CVDocument: Codable, Equatable, Sendable {
    public let frontMatter: [String: String]
    // swiftlint:disable:next identifier_name
    public let cv: CV
    public let links: DocumentLinks
    public let publicEvidence: [PublicEvidence]
    public let rendering: RenderingOptions

    private enum CodingKeys: String, CodingKey {
        case frontMatter
        // swiftlint:disable:next identifier_name
        case cv
        case links
        case publicEvidence
        case rendering
    }

    public init(
        frontMatter: [String: String] = [:],
        // swiftlint:disable:next identifier_name
        cv: CV,
        links: DocumentLinks = .init(),
        publicEvidence: [PublicEvidence] = [],
        rendering: RenderingOptions = .init(),
    ) {
        self.frontMatter = frontMatter
        self.cv = cv
        self.links = links
        self.publicEvidence = publicEvidence
        self.rendering = rendering
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        frontMatter = try container.decode([String: String].self, forKey: .frontMatter, defaultIfMissing: [:])
        cv = try container.decode(CV.self, forKey: .cv)
        links = try container.decode(DocumentLinks.self, forKey: .links, defaultIfMissing: .init())
        publicEvidence = try container.decode([PublicEvidence].self, forKey: .publicEvidence, defaultIfMissing: [])
        rendering = try container.decode(RenderingOptions.self, forKey: .rendering, defaultIfMissing: .init())
    }
}
