import Foundation
import Testing
@testable import CVBuilder

@Suite("CVDocument Schema")
struct CVDocumentSchemaTests {
    private let evidenceSummary = "Maintains a Swift package that generates typed clients from checked-in contracts."

    @Test("document preserves front matter, links, evidence, and technical focus")
    func documentRoundTripsPublishableTechnicalCV() throws {
        let document = try makeDocument()
        let data = try JSONEncoder().encode(document)
        let decoded = try JSONDecoder().decode(CVDocument.self, from: data)

        #expect(decoded == document)
        #expect(decoded.frontMatter["slug"] == "demo-cv")
        #expect(decoded.links.downloads.first?.url == "/assets/demo-cv.pdf")
        #expect(decoded.links.companyURLs["Northbridge Systems"] == "https://example.com/northbridge")
        #expect(decoded.publicEvidence.first?.summary == evidenceSummary)
        #expect(decoded.cv.experience.first?.technicalFocus?.areas == ["Modular architecture"])
        #expect(decoded.cv.experience.first?.projects.first?.technicalFocus?.tags == ["openapi", "spm"])
        #expect(decoded.cv.experience.first?.projects.first?.project.technicalFocus?.areas == ["API tooling"])
    }

    @Test("public evidence carries context beyond a link")
    func publicEvidenceIncludesSummaryRoleTechnologiesAndFocus() throws {
        let document = try makeDocument()
        let evidence = try #require(document.publicEvidence.first)

        #expect(evidence.kind == .openSource)
        #expect(evidence.role == "Maintainer")
        #expect(evidence.summary.contains("typed clients"))
        #expect(evidence.technologies == ["Swift", "OpenAPI"])
        #expect(evidence.technicalFocus?.tags == ["code-generation", "contracts"])
    }

    @Test("rendering options express ordering without scores")
    func renderingOptionsStayFactual() {
        let options = RenderingOptions(
            mode: .experiencedTechnical,
            recentCompanyCount: 3,
            maxBulletsPerProject: 4
        )

        #expect(options.mode == .experiencedTechnical)
        #expect(options.nestProjectsUnderRoles)
        #expect(options.compactGroupedSkills)
        #expect(options.omitEmptySections)
    }

    private func makeDocument() throws -> CVDocument {
        let period = makePeriod()
        let company = try makeCompany()
        let role = try makeRole()
        let project = try makeProject(company: company, role: role, period: period)
        let projectExperience = try makeProjectExperience(project: project, role: role, period: period)
        let work = try makeWork(company: company, role: role, period: period, projectExperience: projectExperience)

        return CVDocument(
            frontMatter: makeFrontMatter(),
            cv: try makeResume(period: period, work: work),
            links: makeLinks(),
            publicEvidence: [try makePublicEvidence()],
            rendering: RenderingOptions(
                mode: .experiencedTechnical,
                recentCompanyCount: 3,
                maxBulletsPerProject: 4
            )
        )
    }

    private func makeFrontMatter() -> [String: String] {
        [
            "layout": "cv",
            "slug": "demo-cv",
            "title": "Demo Curriculum Vitae"
        ]
    }

    private func makeLinks() -> DocumentLinks {
        DocumentLinks(
            profiles: [Link(label: "GitHub", url: "https://example.com/github")],
            downloads: [Link(label: "PDF", url: "/assets/demo-cv.pdf")],
            companyURLs: ["Northbridge Systems": "https://example.com/northbridge"]
        )
    }

    private func makeCompany() throws -> Company {
        try Company(
            id: uuid("00000000-0000-0000-0000-000000000101"),
            name: "Northbridge Systems"
        )
    }

    private func makeRole() throws -> Role {
        try Role(
            id: uuid("00000000-0000-0000-0000-000000000102"),
            title: "Mobile Architect",
            seniority: .senior
        )
    }

    private func makePeriod() -> Period {
        Period(
            start: .init(month: 9, year: 2025),
            end: .init(month: 5, year: 2026)
        )
    }

    private func makeProject(company: Company, role: Role, period: Period) throws -> Project {
        try Project(
            id: uuid("00000000-0000-0000-0000-000000000103"),
            name: "Contract Tooling",
            company: company,
            descriptions: ["Generated typed Swift clients from checked-in API contracts."],
            techs: [
                Tech(
                    id: uuid("00000000-0000-0000-0000-000000000104"),
                    name: "Swift",
                    category: .language
                )
            ],
            role: role,
            period: period,
            technicalFocus: .init(areas: ["API tooling"], tags: ["openapi"])
        )
    }

    private func makeProjectExperience(project: Project, role: Role, period: Period) throws -> ProjectExperience {
        try ProjectExperience(
            id: uuid("00000000-0000-0000-0000-000000000105"),
            project: project,
            role: role,
            period: period,
            technicalFocus: .init(areas: ["Package design"], tags: ["openapi", "spm"])
        )
    }

    private func makeWork(
        company: Company,
        role: Role,
        period: Period,
        projectExperience: ProjectExperience
    ) throws -> WorkExperience {
        try WorkExperience(
            id: uuid("00000000-0000-0000-0000-000000000106"),
            company: company,
            role: role,
            period: period,
            projects: [projectExperience],
            isCurrent: true,
            technicalFocus: .init(areas: ["Modular architecture"], tags: ["swift"])
        )
    }

    private func makeResume(period: Period, work: WorkExperience) throws -> CV {
        try CV(
            id: uuid("00000000-0000-0000-0000-000000000107"),
            name: "Alex Rivera",
            title: "Senior Mobile Architect",
            summary: "Builds modular Swift products and developer tools.",
            contactInfo: ContactInfo(
                email: "alex.rivera@example.com",
                phone: "+1 555 010 0199",
                linkedIn: URL(string: "https://example.com/linkedin"),
                github: URL(string: "https://example.com/github"),
                website: URL(string: "https://example.com"),
                location: "Example City"
            ),
            experience: [work],
            education: [try makeEducation(period: period)],
            skills: [try makeSkill()]
        )
    }

    private func makeEducation(period: Period) throws -> Education {
        try Education(
            id: uuid("00000000-0000-0000-0000-000000000108"),
            institution: "Example Metropolitan University",
            degree: "MSc",
            field: "Human-Computer Information Systems",
            period: period
        )
    }

    private func makeSkill() throws -> Tech {
        try Tech(
            id: uuid("00000000-0000-0000-0000-000000000109"),
            name: "OpenAPI",
            category: .tool
        )
    }

    private func makePublicEvidence() throws -> PublicEvidence {
        try PublicEvidence(
            id: uuid("00000000-0000-0000-0000-000000000110"),
            title: "Contract Tooling",
            kind: .openSource,
            role: "Maintainer",
            summary: evidenceSummary,
            url: "https://example.com/contract-tooling",
            technologies: ["Swift", "OpenAPI"],
            date: "2026",
            highlights: ["Designed the package boundary and test fixtures."],
            technicalFocus: .init(areas: ["Developer tooling"], tags: ["code-generation", "contracts"])
        )
    }

    private func uuid(_ value: String) throws -> UUID {
        try #require(UUID(uuidString: value))
    }
}
