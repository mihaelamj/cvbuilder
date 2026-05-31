@testable import CVBuilder
import Foundation
import Testing

@Suite("MarkdownDocumentRenderer")
struct MarkdownDocumentRendererTests {
    @Test("rendering is byte-for-byte deterministic")
    func renderingIsDeterministic() throws {
        let document = try decode(fullDocumentJSON)
        let renderer = Rendering.MarkdownDocumentRenderer()

        #expect(renderer.render(document) == renderer.render(document))
    }

    @Test("experienced mode renders the proof-backed document shape")
    func experiencedModeRendersDocumentShape() throws {
        let document = try decode(fullDocumentJSON)
        let output = Rendering.MarkdownDocumentRenderer().render(document)

        #expect(output.hasPrefix("""
        ---
        slug: demo-cv
        title: Demo CV
        ---

        # Alex Example
        """))
        let roleHeading = "### [Example Systems](https://example.com/company) - Senior Mobile Architect"

        #expect(output.contains("## Experience"))
        #expect(output.contains(roleHeading))
        #expect(output.contains("Technical focus: Architecture"))
        #expect(output.contains("#### Contract Tooling"))
        #expect(output.contains("Technologies: Swift"))
        #expect(output.contains("## Public Evidence"))
        #expect(output.contains("### [Contract Tooling](https://example.com/tooling)"))
        #expect(output.contains("Summary: Maintains release notes for the package."))
        #expect(output.contains("Tools: OpenAPI"))
    }

    @Test("experienced and early-career modes use different ordering")
    func modeChangesSectionOrdering() throws {
        let experiencedDocument = try decode(fullDocumentJSON)
        let earlyCareerDocument = CVDocument(
            frontMatter: experiencedDocument.frontMatter,
            cv: experiencedDocument.cv,
            links: experiencedDocument.links,
            publicEvidence: experiencedDocument.publicEvidence,
            rendering: RenderingOptions(mode: .earlyCareerTechnical)
        )
        let renderer = Rendering.MarkdownDocumentRenderer()
        let experienced = renderer.render(experiencedDocument)
        let earlyCareer = renderer.render(earlyCareerDocument)
        let experiencedExperienceIndex = try index(of: "## Experience", in: experienced)
        let experiencedEducationIndex = try index(of: "## Education", in: experienced)
        let earlyCareerEducationIndex = try index(of: "## Education", in: earlyCareer)
        let earlyCareerExperienceIndex = try index(of: "## Experience", in: earlyCareer)

        #expect(experienced != earlyCareer)
        #expect(experiencedExperienceIndex < experiencedEducationIndex)
        #expect(earlyCareerEducationIndex < earlyCareerExperienceIndex)
    }

    @Test("renderer omits visual scoring demographic and table artifacts")
    func omitsProhibitedArtifacts() throws {
        let output = try Rendering.MarkdownDocumentRenderer().render(decode(fullDocumentJSON)).lowercased()

        #expect(!output.contains("|"))
        #expect(!output.contains("!["))
        #expect(!output.contains("score"))
        #expect(!output.contains("fit score"))
        #expect(!output.contains("personality"))
        #expect(!output.contains("culture fit"))
        #expect(!output.contains("photo"))
        #expect(!output.contains("birthdate"))
        #expect(!output.contains("nationality"))
        #expect(!output.contains("marital status"))
    }

    @Test("empty optional sections are omitted")
    func omitsEmptyOptionalSections() throws {
        let output = try Rendering.MarkdownDocumentRenderer().render(decode(minimalDocumentJSON))

        #expect(output.contains("## Contact"))
        #expect(!output.contains("## Experience"))
        #expect(!output.contains("## Education"))
        #expect(!output.contains("## Public Evidence"))
        #expect(!output.contains("## Skills"))
        #expect(!output.contains("## Links"))
    }

    @Test("non-positive rendering limits do not erase core facts")
    func nonPositiveLimitsDoNotEraseCoreFacts() throws {
        let document = try decode(fullDocumentJSON)
        let documentWithInvalidLimits = CVDocument(
            frontMatter: document.frontMatter,
            cv: document.cv,
            links: document.links,
            publicEvidence: document.publicEvidence,
            rendering: RenderingOptions(
                recentCompanyCount: -1,
                maxBulletsPerProject: -1
            )
        )
        let output = Rendering.MarkdownDocumentRenderer().render(documentWithInvalidLimits)
        let roleHeading = "### [Example Systems](https://example.com/company) - Senior Mobile Architect"

        #expect(output.contains(roleHeading))
        #expect(output.contains("Built a Swift package."))
    }

    @Test("legacy CV-only Markdown renderer remains available")
    func legacyMarkdownCVRendererStillRendersCV() throws {
        let document = try decode(fullDocumentJSON)
        let renderer: any CVRendering = MarkdownCVRenderer()

        #expect(renderer.render(cv: document.cv).contains("# Alex Example"))
    }

    private func decode(_ json: String) throws -> CVDocument {
        let data = try #require(json.data(using: .utf8))
        return try JSONDecoder().decode(CVDocument.self, from: data)
    }

    private func index(of needle: String, in haystack: String) throws -> String.Index {
        try #require(haystack.range(of: needle)?.lowerBound)
    }
}
