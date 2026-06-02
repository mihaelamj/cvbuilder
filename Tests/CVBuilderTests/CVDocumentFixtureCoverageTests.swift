@testable import CVBuilder
import Foundation
import Testing

@Suite("CVDocument fixture coverage")
struct CVDocumentFixtureCoverageTests {
    @Test("required document fixtures decode, render, and remain privacy safe", arguments: DocumentFixture.allCases)
    func requiredFixturesDecodeRenderAndRemainPrivacySafe(fixture: DocumentFixture) throws {
        let document = try load(fixture)
        let source = try fixtureText(fixture)
        let output = Rendering.MarkdownDocumentRenderer().render(document)

        #expect(!output.isEmpty)
        #expect(document.cv.contactInfo.email.hasSuffix("@example.com"))
        #expect(document.cv.contactInfo.phone.hasPrefix("+1 555 "))
        expectExampleOrLocalURLs(in: document)
        expectNoSourceIdentifiers(in: source)
        expectNoProhibitedGeneratedFields(in: output)
    }

    @Test("minimal fixture omits optional arrays and IDs")
    func minimalFixtureOmitsOptionalArraysAndIDs() throws {
        let document = try load(.minimal)
        let output = Rendering.MarkdownDocumentRenderer().render(document)

        #expect(document.frontMatter.isEmpty)
        #expect(document.cv.experience.isEmpty)
        #expect(document.cv.education.isEmpty)
        #expect(document.cv.skills.isEmpty)
        #expect(document.links == DocumentLinks())
        #expect(document.publicEvidence.isEmpty)
        #expect(document.rendering == RenderingOptions())
        #expect(document.cv.id == nil)
        #expect(output.contains("## Contact"))
        #expect(!output.contains("## Experience"))
        #expect(!output.contains("## Education"))
        #expect(!output.contains("## Public Evidence"))
        #expect(!output.contains("## Skills"))
        #expect(!output.contains("## Links"))
    }

    @Test("early career fixture promotes education before experience")
    func earlyCareerFixturePromotesEducationBeforeExperience() throws {
        let output = try rendered(.earlyCareerTechnical)
        let contact = try index(of: "## Contact", in: output)
        let education = try index(of: "## Education", in: output)
        let evidence = try index(of: "## Public Evidence", in: output)
        let experience = try index(of: "## Experience", in: output)
        let skills = try index(of: "## Skills", in: output)
        let links = try index(of: "## Links", in: output)

        #expect(contact < education)
        #expect(education < evidence)
        #expect(evidence < experience)
        #expect(experience < skills)
        #expect(skills < links)
        #expect(output.contains("### Example Institute of Technology"))
        #expect(output.contains("### [Harbor Example Labs](https://example.com/harbor-example-labs)"))
        #expect(output.contains("#### Clinic Scheduling Prototype"))
        #expect(output.contains("Technical focus: Test coverage, Fixture-driven UI, Date grouping"))
        #expect(output.contains("Kind: Technical writing"))
        #expect(output.contains("Tools: GitHub Actions"))
        #expect(output.contains("Platforms: Linux"))
    }

    @Test("democv fixture proves senior technical rendering behavior")
    func demoCVFixtureProvesSeniorTechnicalRenderingBehavior() throws {
        let document = try load(.demoCV)
        let output = Rendering.MarkdownDocumentRenderer().render(document)
        let experience = try index(of: "## Experience", in: output)
        let education = try index(of: "## Education", in: output)

        #expect(document.cv.name == "Alex Rivera")
        #expect(document.cv.experience.count == 5)
        #expect(document.cv.experience.contains { $0.projects.count >= 2 })
        #expect(document.publicEvidence.contains { $0.kind == .technicalWriting })
        #expect(document.publicEvidence.contains { $0.kind == .talk })
        #expect(output.contains("#### Identity Capture Platform"))
        #expect(output.contains("#### API Contract Tooling"))
        #expect(output.contains("Technical focus: Package design, Identity capture"))
        #expect(output.contains("Summary: Maintains a Swift package"))
        #expect(output.contains("Languages: Swift, Objective-C"))
        #expect(output.contains("Concepts: Unit Testing, UI Testing, Structured Concurrency, Accessibility"))
        #expect(!output.contains("### [Signal Gate](https://example.com/signal-gate)"))
        #expect(!output.contains("### [BrightApps Lab](https://example.com/brightapps)"))
        #expect(!output.contains("## Projects"))
        #expect(experience < education)
    }

    @Test("hostile Markdown fixture escapes source data")
    func hostileMarkdownFixtureEscapesSourceData() throws {
        let output = try rendered(.hostileMarkdown)

        #expect(output.contains("# \\# Mallory \\#\\# Forged"))
        #expect(output.contains("\\- Project \\[link\\]"))
        #expect(output.contains("\\---"))
        #expect(output.contains("\\*OpenAPI\\*"))
        #expect(output.contains("\\_internal\\_"))
        #expect(output.contains("1\\. Ordered + plus \\| a \\| b \\|"))
        #expect(output.contains("\\<admin@example.com\\>"))
        #expect(output.contains("\\[text\\]\\(https://bad\\)"))
        #expect(output.contains("https://example.com/profile%20path%281%29%0Anext"))
        #expect(output.contains("/assets/CV%20%28final%29.md"))
        #expect(!output.contains("\n## Forged"))
        #expect(!output.contains("\n# heading"))
        #expect(!output.contains("\n- list"))
        #expect(!output.contains("\n+ plus"))
        #expect(!output.contains("| a | b |"))
        #expect(!output.contains("[text](https://bad)"))
    }

    private func rendered(_ fixture: DocumentFixture) throws -> String {
        try Rendering.MarkdownDocumentRenderer().render(load(fixture))
    }

    private func load(_ fixture: DocumentFixture) throws -> CVDocument {
        let data = try Data(contentsOf: fixtureURL(fixture.path))
        return try JSONDecoder().decode(CVDocument.self, from: data)
    }

    private func fixtureText(_ fixture: DocumentFixture) throws -> String {
        try String(contentsOf: fixtureURL(fixture.path), encoding: .utf8)
    }

    private func fixtureURL(_ relativePath: String) -> URL {
        let testsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        return testsDirectory
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(relativePath)
    }

    private func index(of needle: String, in haystack: String) throws -> String.Index {
        try #require(haystack.range(of: needle)?.lowerBound)
    }

    private func expectExampleOrLocalURLs(in document: CVDocument) {
        let values = publicURLStrings(in: document)

        for value in values {
            #expect(value.hasPrefix("https://example.com/") || value.hasPrefix("/"))
            #expect(!value.contains("github.com/"))
            #expect(!value.contains("linkedin.com/"))
        }
    }

    private func publicURLStrings(in document: CVDocument) -> [String] {
        let contact = [
            document.cv.contactInfo.linkedIn?.absoluteString,
            document.cv.contactInfo.github?.absoluteString,
            document.cv.contactInfo.website?.absoluteString,
        ].compactMap(\.self)
        let links = (document.links.profiles + document.links.downloads).map(\.url)
        let companyURLs = Array(document.links.companyURLs.values)
        let evidenceURLs = document.publicEvidence.map(\.url)
        let projectURLs = document.cv.experience.flatMap { work in
            work.projects.flatMap { projectExperience in
                projectExperience.project.urls?.map(\.absoluteString) ?? []
            }
        }

        return contact + links + companyURLs + evidenceURLs + projectURLs
    }

    private func expectNoSourceIdentifiers(in source: String) {
        let forbiddenIdentifiers = [
            "aleahim",
            "diyamantina",
            "mihaela",
            "linkedin.com",
            "github.com/",
            "private-user-images.githubusercontent.com",
        ]
        let lowercasedSource = source.lowercased()

        for identifier in forbiddenIdentifiers {
            #expect(!lowercasedSource.contains(identifier))
        }
    }

    private func expectNoProhibitedGeneratedFields(in output: String) {
        let prohibitedTerms = [
            "score",
            "fit score",
            "photo",
            "personality",
            "culture fit",
            "skill bar",
            "birthdate",
            "nationality",
            "marital status",
        ]
        let lowercasedOutput = output.lowercased()

        for term in prohibitedTerms {
            #expect(!lowercasedOutput.contains(term))
        }

        #expect(!output.contains("!["))
    }
}

enum DocumentFixture: CaseIterable {
    case demoCV
    case earlyCareerTechnical
    case hostileMarkdown
    case minimal

    var path: String {
        switch self {
        case .demoCV:
            "Examples/democv/cv.json"
        case .earlyCareerTechnical:
            "Tests/CVBuilderTests/Fixtures/Documents/earlyCareerTechnical.json"
        case .hostileMarkdown:
            "Tests/CVBuilderTests/Fixtures/Documents/hostileMarkdown.json"
        case .minimal:
            "Tests/CVBuilderTests/Fixtures/Documents/minimal.json"
        }
    }
}
