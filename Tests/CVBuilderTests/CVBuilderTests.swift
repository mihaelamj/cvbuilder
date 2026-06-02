@testable import CVBuilder
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
        withIntermediateDirectories: true,
    )
    let outputURL = outputDirectory.appendingPathComponent("CV.md")
    try MarkdownCVRenderer().save(to: outputURL, cv: resume)

    let markdown = try String(contentsOf: outputURL, encoding: .utf8)
    #expect(markdown == Rendering.MarkdownDocumentRenderer().render(CVDocument(cv: resume)))
    #expect(markdown.contains("# \(resume.name)"))
    #expect(markdown.contains("## Skills"))
    #expect(!markdown.contains("Created with"))
}

#if os(Linux)
    @Test func tileDownRendererUsesCVMarkdown() throws {
        let resume = try makeDemoCV()
        let document = CVDocument(
            frontMatter: ["slug": "tile-down-cv"],
            cv: resume,
        )
        let renderer = CVBuilderTileDown.Renderer()

        let text = renderer.render(document)

        #expect(text == Rendering.MarkdownDocumentRenderer().render(document))
    }

    @Test func tileDownRendererUsesLegacyCVMarkdown() throws {
        let resume = try makeDemoCV()
        let renderer = CVBuilderTileDown.Renderer()
        let document = CVDocument(cv: resume)

        let text = renderer.render(cv: resume)

        #expect(text == Rendering.MarkdownDocumentRenderer().render(document))
    }

    @Test func tileDownLegacyCVPathEscapesMarkdownAndOmitsAttribution() {
        let resume = makeHostileCV()
        let renderer = CVBuilderTileDown.Renderer()
        let document = CVDocument(cv: resume)

        let firstRender = renderer.render(cv: resume)
        let secondRender = renderer.render(cv: resume)

        #expect(firstRender == secondRender)
        #expect(firstRender == Rendering.MarkdownDocumentRenderer().render(document))
        #expect(firstRender.contains("# \\# Mallory \\#\\# Forged"))
        #expect(firstRender.contains("\\[text\\]\\(https://bad\\)"))
        #expect(firstRender.contains("\\- Project \\[link\\]"))
        #expect(firstRender.contains("Swift\\|Table"))
        #expect(!firstRender.contains("Created with"))
        #expect(!firstRender.contains("[CVBuilder](https://github.com/mihaelamj/cvbuilder)"))
        #expect(!firstRender.contains("\n## Forged"))
        #expect(!firstRender.contains("\n- list"))
        #expect(!firstRender.contains("[text](https://bad)"))
    }
#endif

private func makeDemoCV() throws -> CV {
    let period = Period(
        start: .init(month: 1, year: 2024),
        end: .init(month: 6, year: 2026),
    )

    return try CV(
        id: uuid("00000000-0000-0000-0000-000000000701"),
        name: "Demo Candidate",
        title: "Senior Swift Engineer",
        summary: "Builds typed Swift tooling for document workflows.",
        contactInfo: ContactInfo(
            email: "demo.candidate@example.com",
            phone: "+1 555 010 0701",
            location: "Example City",
        ),
        experience: [],
        education: [
            Education(
                id: uuid("00000000-0000-0000-0000-000000000702"),
                institution: "Example University",
                degree: "MSc",
                field: "Software Engineering",
                period: period,
            ),
        ],
        skills: [
            Tech(
                id: uuid("00000000-0000-0000-0000-000000000703"),
                name: "Swift",
                category: .language,
            ),
        ],
    )
}

private func makeHostileCV() -> CV {
    let period = Period(
        start: .init(month: 1, year: 2024),
        end: .init(month: 6, year: 2026),
    )
    let company = Company(name: "ACME | Labs [evil](x)")
    let role = Role(title: "Engineer", seniority: .senior)
    let project = Project(
        name: "- Project [link]",
        company: company,
        descriptions: [
            "---",
            "# heading\n- list\n1. Ordered\n+ plus\n| a | b |\n<admin@example.com>\n[text](https://bad)",
        ],
        techs: [
            Tech(name: "Swift|Table", category: .language),
            Tech(name: "*OpenAPI*", category: .tool),
        ],
        role: role,
        period: period,
    )
    let projectExperience = ProjectExperience(project: project, role: role, period: period)
    let work = WorkExperience(
        company: company,
        role: role,
        period: period,
        projects: [projectExperience],
    )

    return CV(
        name: "# Mallory\n## Forged",
        title: "- Lead *Swift* [x](bad)",
        summary: "1. Ordered\n+ plus\n| a | b |\n<admin@example.com>\n[text](https://bad)",
        contactInfo: ContactInfo(
            email: "mallory@example.com",
            phone: "+1 555 010 0105",
            location: "Example City",
        ),
        experience: [work],
        education: [
            Education(
                institution: "# University",
                degree: "MSc",
                field: "Security|Parsing",
                period: period,
            ),
        ],
        skills: [
            Tech(name: "*OpenAPI*", category: .tool),
            Tech(name: "_internal_", category: .tool),
        ],
    )
}

private func uuid(_ value: String) throws -> UUID {
    try #require(UUID(uuidString: value))
}
