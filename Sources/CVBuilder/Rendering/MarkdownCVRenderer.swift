import Foundation

/// Deprecated Markdown renderer that bridges a bare `CV` to the canonical
/// `CVDocument` Markdown renderer, so legacy callers get the same escaping and
/// deterministic ordering. Use `CVDocument` with
/// `Rendering.MarkdownDocumentRenderer` directly.
@available(*, deprecated, message: "Use CVDocument with Rendering.MarkdownDocumentRenderer.")
public struct MarkdownCVRenderer: CVRendering, Sendable {
    public var experienceTitle: String {
        "EXPERIENCE"
    }

    public var skillsTitle: String {
        "SKILLS"
    }

    public init() {}

    /// Renders the CV as Markdown by wrapping it in a default `CVDocument`.
    public func render(cv resume: CV) -> String {
        Rendering.MarkdownDocumentRenderer().render(CVDocument(cv: resume))
    }

    /// Renders the CV and writes the Markdown to `url` as UTF-8.
    public func save(to url: URL, cv resume: CV) throws {
        let content = render(cv: resume)
        try content.write(to: url, atomically: true, encoding: .utf8)
    }

    /// Renders the CV and prints the Markdown to standard output.
    public func printToConsole(cv resume: CV) {
        print(render(cv: resume))
    }
}
