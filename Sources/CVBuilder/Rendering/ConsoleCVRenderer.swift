import Foundation

/// Deprecated console renderer that produces the plain-text `CV` rendering for
/// standard output. Use `CVDocument` with `Rendering.MarkdownDocumentRenderer`.
@available(*, deprecated, message: "Use CVDocument with Rendering.MarkdownDocumentRenderer.")
public struct ConsoleCVRenderer: CVRendering, Sendable {
    public var experienceTitle: String {
        "EXPERIENCE"
    }

    public var skillsTitle: String {
        "SKILLS"
    }

    public init() {}

    /// Renders the CV as the plain-text string form.
    public func render(cv resume: CV) -> String {
        StringCVRenderer().render(cv: resume)
    }

    /// Always throws: the console renderer writes to standard output and does
    /// not support file output.
    public func save(to _: URL, cv _: CV) throws {
        throw NSError(
            domain: "ConsoleRenderer",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Cannot save console output."],
        )
    }

    /// Renders the CV and prints the plain-text form to standard output.
    public func printToConsole(cv resume: CV) {
        print(render(cv: resume))
    }
}
