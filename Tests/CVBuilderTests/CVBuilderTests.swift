@testable import CVBuilder
import CVBuilderIgnite
import Foundation
import Testing
#if os(Linux)
    import CVBuilderTileDown
#endif

@Test func creatingCV() throws {
    let resume = CV.createExampleCV()

    #expect(resume.title == "Senior iOS Architect | Swift Server & OpenAPI | AI Tooling")

    let outputURL = FileManager.default.temporaryDirectory
        .appendingPathComponent("cvbuilder-\(UUID().uuidString)")
        .appendingPathComponent("CV.md")
    try MarkdownCVRenderer().save(to: outputURL, cv: resume)

    let markdown = try String(contentsOf: outputURL, encoding: .utf8)
    #expect(markdown.contains("# \(resume.name)"))
    #expect(markdown.contains("## EXPERIENCE"))
}

@Test func igniteRendererIsImportable() {
    let renderer = IgniteRenderer(cv: CV.createExampleCV())

    _ = renderer
}

#if os(Linux)
    @Test func tileDownRendererUsesCVMarkdown() {
        let resume = CV.createExampleCV()
        let document = CVDocument(
            frontMatter: ["slug": "tile-down-cv"],
            cv: resume
        )
        let renderer = CVBuilderTileDown.Renderer()

        let text = renderer.render(document)

        #expect(text.contains("slug: \"tile-down-cv\""))
        #expect(text.contains("# \(resume.name)"))
        #expect(text.contains("## Experience"))
    }

    @Test func tileDownRendererUsesLegacyCVMarkdown() {
        let resume = CV.createExampleCV()
        let renderer = CVBuilderTileDown.Renderer()

        let text = renderer.render(cv: resume)

        #expect(text.contains("# \(resume.name)"))
        #expect(text.contains("## EXPERIENCE"))
    }
#endif
