@testable import CVBuilder
import Foundation
import Testing

/// Regression coverage for empty/whitespace field guards before structural
/// Markdown (#130) and the placeholder-role / companyURLs edge cases (#125).
@Suite("Empty-field rendering guards")
struct EmptyFieldRenderingTests {
    private let renderer = Rendering.MarkdownDocumentRenderer()

    // MARK: - #130.1 empty-label links

    @Test("an empty or whitespace link label falls back to the destination text")
    func emptyLinkLabelFallsBackToDestination() {
        #expect(renderer.linkedText("  ", destination: "https://x.com/p") == "[https://x.com/p](https://x.com/p)")
        #expect(renderer.linkedText("Label", destination: "https://x.com/p") == "[Label](https://x.com/p)")
        // A destination that normalizes to blank yields no link at all.
        #expect(renderer.linkedText("", destination: "\u{0000}") == "")
    }

    @Test("a whitespace-only profile label renders the destination, never []()")
    func whitespaceProfileLabelRendersDestination() {
        let document = CVDocument(
            cv: minimalCV,
            links: DocumentLinks(profiles: [Link(label: "  ", url: "https://x.com/p")]),
        )
        let output = renderer.render(document)

        #expect(output.contains("[https://x.com/p](https://x.com/p)"))
        #expect(!output.contains("[]("))
    }

    // MARK: - #130.2 bare evidence heading

    @Test("a whitespace evidence title with a url renders a linked heading, not []()")
    func evidenceWhitespaceTitleWithURL() {
        let output = renderEvidence(PublicEvidence(title: "  ", kind: .app, role: "", summary: "", url: "https://e.com"))

        #expect(output.contains("### [https://e.com](https://e.com)"))
        #expect(!output.contains("### \n"))
    }

    @Test("a whitespace evidence title with no url falls back to the kind, never a bare heading")
    func evidenceWhitespaceTitleNoURL() {
        let output = renderEvidence(PublicEvidence(title: "  ", kind: .app, role: "", summary: "", url: "  "))

        #expect(output.contains("### App"))
        #expect(!output.split(separator: "\n").contains("### "))
    }

    // MARK: - #130.3 dangling degree/field connector

    @Test("the degree/field line emits only the present side")
    func degreeFieldLineOmitsMissingSide() {
        #expect(renderer.degreeFieldLine(degree: "MSc", field: "CS") == "MSc in CS")
        #expect(renderer.degreeFieldLine(degree: "MSc", field: "") == "MSc")
        #expect(renderer.degreeFieldLine(degree: "  ", field: "CS") == "CS")
        #expect(renderer.degreeFieldLine(degree: "", field: "") == nil)
    }

    // MARK: - #125.1 placeholder role

    @Test("the unset placeholder role is detected")
    func placeholderRoleDetection() {
        #expect(Role.none.isPlaceholder)
        #expect(Role(title: "  ", seniority: .mid).isPlaceholder)
        #expect(!Role(title: "iOS Engineer", seniority: .senior).isPlaceholder)
    }

    @Test("a project with the placeholder role renders no Role line")
    func placeholderRoleRendersNoRoleLine() {
        let project = Project(
            name: "Side Project",
            company: Company(name: "Acme"),
            descriptions: ["Did the thing."],
            techs: [],
            role: .none,
            period: Period(start: .init(month: 1, year: 2023), end: .init(month: 6, year: 2023)),
        )
        let work = WorkExperience(
            company: Company(name: "Acme"),
            role: Role(title: "Engineer", seniority: .senior),
            period: Period(start: .init(month: 1, year: 2023), end: .init(month: 6, year: 2023)),
            projects: [ProjectExperience(project: project, role: .none, period: project.period)],
        )
        let document = CVDocument(cv: cv(experience: [work]), rendering: RenderingOptions(nestProjectsUnderRoles: true))
        let output = renderer.render(document)

        #expect(output.contains("#### Side Project"))
        #expect(!output.contains("Role: Junior Unknown"))
    }

    // MARK: - #125.2 companyURLs whitespace-insensitive lookup

    @Test("company URL lookup tolerates trailing whitespace in the key")
    func companyURLToleratesWhitespace() {
        #expect(renderer.companyURL(for: "Acme Corp", in: ["Acme Corp ": "https://acme.com"]) == "https://acme.com")
        #expect(renderer.companyURL(for: "Acme Corp", in: ["Acme Corp": "https://acme.com"]) == "https://acme.com")
        #expect(renderer.companyURL(for: "Acme Corp", in: ["Other": "https://x.com"]) == nil)
    }

    // MARK: - Helpers

    private var minimalCV: CV {
        cv(experience: [])
    }

    private func cv(experience: [WorkExperience]) -> CV {
        CV(
            name: "Taylor Example",
            title: "Engineer",
            summary: "Summary",
            contactInfo: ContactInfo(email: "a@b.c", phone: "+100000000", location: "Somewhere"),
            experience: experience,
            education: [],
            skills: [],
        )
    }

    private func renderEvidence(_ evidence: PublicEvidence) -> String {
        let document = CVDocument(
            cv: minimalCV,
            publicEvidence: [evidence],
            rendering: RenderingOptions(mode: .publicEvidenceHeavyTechnical),
        )
        return renderer.render(document)
    }
}
