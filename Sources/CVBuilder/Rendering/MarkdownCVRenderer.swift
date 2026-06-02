import Foundation

@available(*, deprecated, message: "Use CVDocument with Rendering.MarkdownDocumentRenderer.")
public struct MarkdownCVRenderer: CVRendering, Sendable {
    public var experienceTitle: String {
        "EXPERIENCE"
    }

    public var skillsTitle: String {
        "SKILLS"
    }

    public init() {}

    public func render(cv resume: CV) -> String {
        Rendering.MarkdownDocumentRenderer().render(CVDocument(cv: resume))
    }

    public func save(to url: URL, cv resume: CV) throws {
        let content = render(cv: resume)
        try content.write(to: url, atomically: true, encoding: .utf8)
    }

    public func printToConsole(cv resume: CV) {
        print(render(cv: resume))
    }
}
