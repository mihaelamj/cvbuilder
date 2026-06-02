import Foundation

/// Legacy protocol for rendering a bare `CV` to a string.
///
/// Deprecated in favor of `CVDocument` with `Rendering.MarkdownDocumentRenderer`,
/// the canonical, localized, document-aware renderer. Conformers here are
/// English-only compatibility shims with no locale.
@available(*, deprecated, message: "Use CVDocument with Rendering.MarkdownDocumentRenderer.")
public protocol CVRendering {
    /// Renders the CV to a string.
    func render(cv: CV) -> String
    /// Renders the CV and writes it to `url`; throws if writing is unsupported or fails.
    func save(to url: URL, cv: CV) throws
    /// Renders the CV and prints it to standard output.
    func printToConsole(cv: CV)
    /// Heading text for the experience section.
    var experienceTitle: String { get }
    /// Heading text for the skills section.
    var skillsTitle: String { get }
}
