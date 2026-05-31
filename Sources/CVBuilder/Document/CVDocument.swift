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
}
