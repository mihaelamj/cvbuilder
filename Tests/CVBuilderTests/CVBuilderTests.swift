@testable import CVBuilder
import CVBuilderIgnite
import Foundation
import Testing
#if os(Linux)
    import CVBuilderTileDown
#endif

@Test func creatingCV() throws {
    let resume = try makeDemoCV()

    #expect(resume.title == "Senior Swift Engineer")

    let outputDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent("cvbuilder-\(UUID().uuidString)")
    try FileManager.default.createDirectory(
        at: outputDirectory,
        withIntermediateDirectories: true
    )
    let outputURL = outputDirectory.appendingPathComponent("CV.md")
    try MarkdownCVRenderer().save(to: outputURL, cv: resume)

    let markdown = try String(contentsOf: outputURL, encoding: .utf8)
    #expect(markdown.contains("# \(resume.name)"))
    #expect(markdown.contains("## EXPERIENCE"))
}

@Test func igniteRendererIsImportable() throws {
    let renderer = try IgniteRenderer(cv: makeDemoCV())

    _ = renderer
}

#if os(Linux)
    @Test func tileDownRendererUsesCVMarkdown() throws {
        let resume = try makeDemoCV()
        let document = CVDocument(
            frontMatter: ["slug": "tile-down-cv"],
            cv: resume
        )
        let renderer = CVBuilderTileDown.Renderer()

        let text = renderer.render(document)

        #expect(text == Rendering.MarkdownDocumentRenderer().render(document))
    }

    @Test func tileDownRendererUsesLegacyCVMarkdown() throws {
        let resume = try makeDemoCV()
        let renderer = CVBuilderTileDown.Renderer()

        let text = renderer.render(cv: resume)

        #expect(text == MarkdownCVRenderer().render(cv: resume))
    }
#endif

private func makeDemoCV() throws -> CV {
    let period = Period(
        start: .init(month: 1, year: 2024),
        end: .init(month: 6, year: 2026)
    )

    return try CV(
        id: uuid("00000000-0000-0000-0000-000000000701"),
        name: "Demo Candidate",
        title: "Senior Swift Engineer",
        summary: "Builds typed Swift tooling for document workflows.",
        contactInfo: ContactInfo(
            email: "demo.candidate@example.com",
            phone: "+1 555 010 0701",
            location: "Example City"
        ),
        experience: [],
        education: [
            Education(
                id: uuid("00000000-0000-0000-0000-000000000702"),
                institution: "Example University",
                degree: "MSc",
                field: "Software Engineering",
                period: period
            )
        ],
        skills: [
            Tech(
                id: uuid("00000000-0000-0000-0000-000000000703"),
                name: "Swift",
                category: .language
            )
        ]
    )
}

private func uuid(_ value: String) throws -> UUID {
    try #require(UUID(uuidString: value))
}
