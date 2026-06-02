import Foundation

/// A publishable technical CV document.
///
/// `CVDocument` keeps `CV` as the canonical resume data and adds publishing
/// metadata that a generated Markdown page needs: static-site front matter,
/// links, public evidence, and rendering preferences. It does not know about a
/// specific static site generator or output format.
public struct CVDocument: Codable, Equatable, Sendable {
    /// Static-site front matter emitted before the Markdown body.
    ///
    /// The selected `RenderingOptions.frontMatterProfile` controls key order,
    /// delimiters, and value coercion. The generic profile sorts keys and escapes
    /// values as single-line strings.
    public let frontMatter: [String: String]
    /// Canonical resume facts: identity, contact data, work, education, and skills.
    ///
    /// This field is required in JSON. Omitted optional collections inside `CV`
    /// decode as empty collections so handwritten files can stay small.
    // swiftlint:disable:next identifier_name
    public let cv: CV
    /// Document-level links used by generated Markdown.
    ///
    /// Profile and download links render in the `Links` section. `companyURLs`
    /// links matching work-experience company headings.
    public let links: DocumentLinks
    /// Public technical artifacts that support the CV.
    ///
    /// Rendered as `Public Evidence` entries with kind, role, date or period,
    /// summary, technologies, technical focus, and highlights.
    public let publicEvidence: [PublicEvidence]
    /// Markdown ordering and compaction preferences.
    ///
    /// Rendering options affect presentation only. They do not carry scores,
    /// inferred fit, demographic fields, or parser-specific metadata.
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
