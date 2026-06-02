@testable import CVBuilder
import Foundation
import Testing

struct RenderingModeFixture {
    let mode: RenderingMode
    let policyName: String
    let sections: [Rendering.MarkdownDocumentRenderer.Section]
    let fixtureName: String
}

struct FrontMatterProfileFixture {
    let profile: FrontMatterProfile
    let fixtureName: String
}

let renderingModeFixtures = [
    RenderingModeFixture(
        mode: .experiencedTechnical,
        policyName: "Experienced technical CV",
        sections: [.contact, .experience, .projects, .publicEvidence, .skills, .education, .links],
        fixtureName: "experiencedTechnical.md",
    ),
    RenderingModeFixture(
        mode: .earlyCareerTechnical,
        policyName: "Early-career technical CV",
        sections: [.contact, .education, .publicEvidence, .experience, .projects, .skills, .links],
        fixtureName: "earlyCareerTechnical.md",
    ),
    RenderingModeFixture(
        mode: .publicEvidenceHeavyTechnical,
        policyName: "Public-evidence-heavy technical CV",
        sections: [.contact, .publicEvidence, .experience, .projects, .skills, .education, .links],
        fixtureName: "publicEvidenceHeavyTechnical.md",
    ),
]

let frontMatterProfileFixtures = [
    FrontMatterProfileFixture(profile: .generic, fixtureName: "frontMatterGeneric.md"),
    FrontMatterProfileFixture(profile: .toucan, fixtureName: "frontMatterToucan.md"),
    FrontMatterProfileFixture(profile: .hugo, fixtureName: "frontMatterHugo.md"),
    FrontMatterProfileFixture(profile: .jekyll, fixtureName: "frontMatterJekyll.md"),
]

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
        slug: "demo-cv"
        title: "Demo CV"
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

    @Test("rendering modes expose named policies", arguments: renderingModeFixtures)
    func renderingModesExposeNamedPolicies(fixture: RenderingModeFixture) {
        let policy = Rendering.MarkdownDocumentRenderer().policy(for: fixture.mode)

        #expect(policy.name == fixture.policyName)
        #expect(policy.sections == fixture.sections)
    }

    @Test("rendering modes match checked-in Markdown fixtures", arguments: renderingModeFixtures)
    func renderingModesMatchCheckedInMarkdownFixtures(fixture: RenderingModeFixture) throws {
        let document = try democvDocument(renderingMode: fixture.mode)
        let expected = try expectedMarkdownFixture(fixture.fixtureName)
        let output = Rendering.MarkdownDocumentRenderer().render(document)

        #expect(output == expected)
        #expect(output.contains("### [Northbridge Systems](https://example.com/northbridge) - Senior Swift Platform Engineer"))
        #expect(output.contains("#### Identity Capture Platform"))
        #expect(output.contains("#### API Contract Tooling"))
        #expect(output.contains("### [Lumen Works](https://example.com/lumen) - Senior iOS Developer"))
        #expect(output.contains("### [Clearpath Digital](https://example.com/clearpath) - Senior iOS Developer"))
        #expect(!output.contains("### [Signal Gate](https://example.com/signal-gate)"))
        #expect(!output.contains("### [BrightApps Lab](https://example.com/brightapps)"))
        #expect(output.contains("Summary: Maintains a Swift package"))
        #expect(output.contains("[GitHub](https://example.com/alex-rivera-code)"))
        #expect(output.contains("Tools: OpenAPI"))
        #expect(!output.contains("Senior Senior"))
    }

    @Test("rendering mode fixture coverage is complete")
    func renderingModeFixtureCoverageIsComplete() {
        let fixtureModes = renderingModeFixtures.map(\.mode.rawValue).sorted()
        let enumModes = RenderingMode.allCases.map(\.rawValue).sorted()

        #expect(fixtureModes == enumModes)
    }

    @Test("front matter profiles match checked-in Markdown fixtures", arguments: frontMatterProfileFixtures)
    func frontMatterProfilesMatchCheckedInFixtures(fixture: FrontMatterProfileFixture) throws {
        let document = makeFrontMatterProfileDocument(profile: fixture.profile)
        let expected = try expectedMarkdownFixture(fixture.fixtureName)
        let output = Rendering.MarkdownDocumentRenderer().render(document)

        #expect(output == expected)
        #expect(output.contains("# Taylor Example"))
        #expect(output.contains("## Contact"))
    }

    @Test("default front matter profile preserves generic output")
    func defaultFrontMatterProfilePreservesGenericOutput() throws {
        let explicitGeneric = Rendering.MarkdownDocumentRenderer().render(makeFrontMatterProfileDocument(profile: .generic))
        let implicitGeneric = Rendering.MarkdownDocumentRenderer().render(makeFrontMatterProfileDocument(profile: nil))
        let expected = try expectedMarkdownFixture("frontMatterGeneric.md")

        #expect(implicitGeneric == explicitGeneric)
        #expect(implicitGeneric == expected)
    }

    @Test("experienced and early-career modes use different ordering")
    func modeChangesSectionOrdering() throws {
        let experiencedDocument = try decode(fullDocumentJSON)
        let earlyCareerDocument = CVDocument(
            frontMatter: experiencedDocument.frontMatter,
            cv: experiencedDocument.cv,
            links: experiencedDocument.links,
            publicEvidence: experiencedDocument.publicEvidence,
            rendering: RenderingOptions(mode: .earlyCareerTechnical),
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

    @Test("empty optional sections can be emitted as an explicit skeleton")
    func canRenderEmptyOptionalSectionHeadings() throws {
        let document = try decode(minimalDocumentJSON)
        let explicitSkeletonDocument = CVDocument(
            frontMatter: document.frontMatter,
            cv: document.cv,
            links: document.links,
            publicEvidence: document.publicEvidence,
            rendering: RenderingOptions(omitEmptySections: false),
        )
        let output = Rendering.MarkdownDocumentRenderer().render(explicitSkeletonDocument)

        #expect(output.contains("## Contact"))
        #expect(output.contains("## Experience"))
        #expect(output.contains("## Education"))
        #expect(output.contains("## Public Evidence"))
        #expect(output.contains("## Skills"))
        #expect(output.contains("## Links"))
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
                maxBulletsPerProject: -1,
            ),
        )
        let output = Rendering.MarkdownDocumentRenderer().render(documentWithInvalidLimits)
        let roleHeading = "### [Example Systems](https://example.com/company) - Senior Mobile Architect"

        #expect(output.contains(roleHeading))
        #expect(output.contains("Built a Swift package."))
    }

    @Test("positive rendering limits constrain work entries and project descriptions")
    func positiveRenderingLimitsConstrainOutput() {
        let output = Rendering.MarkdownDocumentRenderer().render(
            makeLimitedWorkDocument(rendering: RenderingOptions(
                recentCompanyCount: 1,
                maxBulletsPerProject: 1,
                nestProjectsUnderRoles: false,
            )),
        )

        #expect(output.contains("## Projects"))
        #expect(output.contains("### Visible Project"))
        #expect(output.contains("First visible project fact."))
        #expect(!output.contains("Second hidden project fact."))
        #expect(!output.contains("Hidden Systems"))
    }

    @Test("standalone Projects is a first-class section, ordered after Experience")
    func standaloneProjectsIsFirstClassSection() {
        let output = Rendering.MarkdownDocumentRenderer().render(
            makeLimitedWorkDocument(rendering: RenderingOptions(nestProjectsUnderRoles: false)),
        )

        // Its own block, separated from the Experience block, not welded onto it.
        #expect(output.contains("\n\n## Projects\n"))
        let experienceIndex = output.range(of: "## Experience")?.lowerBound
        let projectsIndex = output.range(of: "## Projects")?.lowerBound
        #expect(experienceIndex != nil)
        #expect(projectsIndex != nil)
        if let experienceIndex, let projectsIndex {
            #expect(experienceIndex < projectsIndex)
        }
    }

    @Test("standalone projects survive when the experience filter empties the list")
    func standaloneProjectsSurviveEmptyExperience() throws {
        let missingID = try #require(UUID(uuidString: "00000000-0000-0000-0000-0000000000FF"))
        let output = Rendering.MarkdownDocumentRenderer().render(
            makeLimitedWorkDocument(rendering: RenderingOptions(
                selectedExperienceIDs: [missingID],
                nestProjectsUnderRoles: false,
            )),
        )

        #expect(output.contains("## Projects"))
        #expect(output.contains("### Visible Project"))
    }

    @Test("explicit selection is not truncated by recentCompanyCount")
    func explicitSelectionIsNotTruncatedByRecencyCap() throws {
        let recentID = try #require(UUID(uuidString: "00000000-0000-0000-0000-000000000401"))
        let selectedID = try #require(UUID(uuidString: "00000000-0000-0000-0000-000000000402"))
        let legacyID = try #require(UUID(uuidString: "00000000-0000-0000-0000-000000000403"))
        let output = try Rendering.MarkdownDocumentRenderer().render(
            makeSelectedWorkDocument(rendering: RenderingOptions(
                recentCompanyCount: 2,
                selectedExperienceIDs: [selectedID, legacyID, recentID],
            )),
        )

        // All three explicitly selected entries render despite recentCompanyCount: 2.
        #expect(output.contains("Selected Platform Lab"))
        #expect(output.contains("Unselected Legacy Works"))
        #expect(output.contains("Recent Hidden Systems"))
    }

    @Test("selected work entries render by explicit id instead of recency")
    func selectedExperienceIDsRenderRelevantOlderWork() throws {
        let selectedID = try #require(UUID(uuidString: "00000000-0000-0000-0000-000000000402"))
        let output = try Rendering.MarkdownDocumentRenderer().render(
            makeSelectedWorkDocument(rendering: RenderingOptions(
                recentCompanyCount: 1,
                selectedExperienceIDs: [selectedID],
            )),
        )

        #expect(output.contains("Selected Platform Lab"))
        #expect(output.contains("Relevant older platform migration."))
        #expect(!output.contains("Recent Hidden Systems"))
        #expect(!output.contains("Unselected Legacy Works"))
    }

    @Test("selected work entries preserve explicit relevance order")
    func selectedExperienceIDsPreserveExplicitOrder() throws {
        let recentID = try #require(UUID(uuidString: "00000000-0000-0000-0000-000000000401"))
        let selectedID = try #require(UUID(uuidString: "00000000-0000-0000-0000-000000000402"))
        let missingID = try #require(UUID(uuidString: "00000000-0000-0000-0000-000000000499"))
        let output = try Rendering.MarkdownDocumentRenderer().render(
            makeSelectedWorkDocument(rendering: RenderingOptions(
                recentCompanyCount: 2,
                selectedExperienceIDs: [selectedID, selectedID, missingID, recentID],
            )),
        )
        let selectedIndex = try index(of: "Selected Platform Lab", in: output)
        let recentIndex = try index(of: "Recent Hidden Systems", in: output)

        #expect(selectedIndex < recentIndex)
        #expect(occurrenceCount(of: "Selected Platform Lab", in: output) == 1)
        #expect(output.contains("Recent but less relevant delivery."))
        #expect(!output.contains("Unselected Legacy Works"))
    }

    @Test("public evidence uses period when display date is absent")
    func publicEvidenceUsesPeriodFallback() {
        let period = Period(start: .init(month: 1, year: 2024), end: .init(month: 6, year: 2026))
        let evidence = PublicEvidence(
            title: "Measured Package",
            kind: .package,
            role: "Maintainer",
            summary: "Measured package reliability.",
            url: "https://example.com/measured",
            date: " ",
            period: period,
        )
        let output = Rendering.MarkdownDocumentRenderer().render(
            makeMinimalDocument(publicEvidence: [evidence]),
        )

        #expect(output.contains("Period: Jan 2024 - Jun 2026"))
        #expect(!output.contains("Date:"))
    }

    @Test("legacy CV-only Markdown renderer remains available")
    func legacyMarkdownCVRendererStillRendersCV() throws {
        let document = try decode(fullDocumentJSON)
        let renderer: any CVRendering = MarkdownCVRenderer()
        let output = renderer.render(cv: document.cv)

        #expect(output == Rendering.MarkdownDocumentRenderer().render(CVDocument(cv: document.cv)))
        #expect(output.contains("# Alex Example"))
        #expect(!output.contains("Created with"))
    }

    @Test("hostile text is escaped as data, not Markdown structure")
    func hostileTextCannotCreateMarkdownStructure() {
        let output = Rendering.MarkdownDocumentRenderer().render(makeHostileDocument())

        #expect(output.contains("# \\# Mallory \\#\\# Forged"))
        #expect(output.contains("\\- Project \\[link\\]"))
        #expect(output.contains("\\---"))
        #expect(output.contains("\\*OpenAPI\\*"))
        #expect(output.contains("\\_internal\\_"))
        #expect(output.contains("1\\. Ordered + plus \\| a \\| b \\|"))
        #expect(output.contains("\\<admin@example.com\\>"))
        #expect(output.contains("\\[text\\]\\(https://bad\\)"))
        #expect(!output.contains("\n## Forged"))
        #expect(!output.contains("\n# forged"))
        #expect(!output.contains("\n- list"))
        #expect(!output.contains("\n+ plus"))
        #expect(!output.contains("\n1. Ordered"))
        #expect(!output.contains("| a | b |"))
        #expect(!output.contains("[text](https://bad)"))
        #expect(output.split(separator: "\n").count(where: { $0 == "---" }) == 2)
    }

    @Test("the legacy WorkExperience.formattedDateRange is English-only")
    func legacyFormattedDateRangeIsEnglishOnly() {
        let period = Period(start: .init(month: 1, year: 2024), end: .init(month: 6, year: 2026))
        let role = Role(title: "Engineer", seniority: .senior)
        let finished = WorkExperience(company: Company(name: "C"), role: role, period: period, projects: [])
        let ongoing = WorkExperience(company: Company(name: "C"), role: role, period: period, projects: [], isCurrent: true)

        #expect(finished.formattedDateRange == "Jan 2024 - Jun 2026")
        #expect(ongoing.formattedDateRange == "Jan 2024 - Present")
    }

    @Test("setext underline field values cannot forge a heading", arguments: ["===", "=", "-", "--", "---"])
    func setextUnderlineFieldsCannotForgeHeading(_ underline: String) {
        let cv = CV(
            name: "Real Name",
            title: "Fake Title",
            summary: underline,
            contactInfo: ContactInfo(email: "a@b.c", phone: "+100000000", location: "Somewhere"),
            experience: [],
            education: [],
            skills: [],
        )
        let output = Rendering.MarkdownDocumentRenderer().render(CVDocument(cv: cv))

        // The underline value is escaped at the line start, so it stays literal
        // text instead of promoting "Fake Title" into a setext heading.
        #expect(output.contains("Fake Title\n\\\(underline)"))
        #expect(!output.split(separator: "\n").contains { String($0) == underline })
    }

    @Test("array keys render an empty array under the profiles that declare them")
    func emptyArrayKeysRenderEmptyArray() {
        for value in ["", "  ", ","] {
            // `tags` is an array key in Toucan, Jekyll (YAML), and Hugo (TOML).
            #expect(renderedFrontMatter(["tags": value], profile: .toucan).contains("tags: []"))
            #expect(renderedFrontMatter(["tags": value], profile: .jekyll).contains("tags: []"))
            #expect(renderedFrontMatter(["tags": value], profile: .hugo).contains("tags = []"))
            // `categories` is an array key in Jekyll and Hugo, but not Toucan.
            #expect(renderedFrontMatter(["categories": value], profile: .jekyll).contains("categories: []"))
            #expect(renderedFrontMatter(["categories": value], profile: .hugo).contains("categories = []"))

            // Never a string scalar and never the raw separator string.
            #expect(!renderedFrontMatter(["tags": value], profile: .toucan).contains("tags: \""))
            #expect(!renderedFrontMatter(["tags": value], profile: .hugo).contains("tags = \""))
        }
    }

    @Test("array keys with empty middle elements drop the blanks")
    func arrayKeysDropEmptyMiddleElements() {
        #expect(renderedFrontMatter(["tags": "a,,b"], profile: .toucan).contains("tags:\n  - \"a\"\n  - \"b\""))
        #expect(renderedFrontMatter(["tags": "a,,b"], profile: .jekyll).contains("tags:\n  - \"a\"\n  - \"b\""))
        #expect(renderedFrontMatter(["tags": "a,,b"], profile: .hugo).contains("tags = [\"a\", \"b\"]"))
        #expect(renderedFrontMatter(["categories": "a,,b"], profile: .jekyll).contains("categories:\n  - \"a\"\n  - \"b\""))
        #expect(renderedFrontMatter(["categories": "a,,b"], profile: .hugo).contains("categories = [\"a\", \"b\"]"))

        // Toucan does not declare `categories`, so it stays a scalar there.
        #expect(renderedFrontMatter(["categories": "a, b"], profile: .toucan).contains("categories: \"a, b\""))
    }

    @Test("boolean coercion is per-profile and accepts wider spellings")
    func booleanCoercionIsPerProfile() {
        // `draft` is a boolean key in Toucan and Hugo, not Jekyll.
        #expect(renderedFrontMatter(["draft": "true"], profile: .toucan).contains("draft: true"))
        #expect(renderedFrontMatter(["draft": "true"], profile: .hugo).contains("draft = true"))
        #expect(renderedFrontMatter(["draft": "true"], profile: .jekyll).contains("draft: \"true\""))

        // `published` is a boolean key in Jekyll, not Hugo.
        #expect(renderedFrontMatter(["published": "false"], profile: .jekyll).contains("published: false"))
        #expect(renderedFrontMatter(["published": "false"], profile: .hugo).contains("published = \"false\""))

        // Wider boolean spellings coerce for a declared boolean key.
        #expect(renderedFrontMatter(["draft": "yes"], profile: .hugo).contains("draft = true"))
        #expect(renderedFrontMatter(["draft": "no"], profile: .toucan).contains("draft: false"))
        #expect(renderedFrontMatter(["draft": "1"], profile: .hugo).contains("draft = true"))

        // An unrecognized boolean spelling falls back to a quoted scalar.
        #expect(renderedFrontMatter(["draft": "maybe"], profile: .hugo).contains("draft = \"maybe\""))
    }

    @Test("the generic profile coerces nothing")
    func genericProfileCoercesNothing() {
        let generic = renderedFrontMatter(["draft": "true", "tags": "a, b"], profile: .generic)

        #expect(generic.contains("draft: \"true\""))
        #expect(generic.contains("tags: \"a, b\""))
    }

    @Test("front matter keys and scalar values are quoted and single-line")
    func frontMatterScalarsAreQuotedAndSingleLine() {
        let document = makeHostileDocument(
            frontMatter: [
                "": "empty key",
                "slug": "hostile cv",
                "title": "Demo: ---\n# forged",
            ],
        )
        let output = Rendering.MarkdownDocumentRenderer().render(document)

        #expect(output.hasPrefix("""
        ---
        "": "empty key"
        slug: "hostile cv"
        title: "Demo: ---\\n# forged"
        ---
        """))
        #expect(!output.contains("\n---\n# forged"))
    }

    @Test("non-compact skills are escaped as an engineering invariant")
    func nonCompactSkillsEscapeHostileSkillNames() {
        let output = Rendering.MarkdownDocumentRenderer().render(
            makeHostileDocument(rendering: RenderingOptions(compactGroupedSkills: false)),
        )

        #expect(output.contains("\\*OpenAPI\\*"))
        #expect(output.contains("\\_internal\\_"))
        #expect(!output.contains("\n*OpenAPI*"))
        #expect(!output.contains("\n_internal_"))
    }

    @Test("unsafe link destinations are encoded consistently")
    func unsafeLinkDestinationsAreEncoded() {
        let output = Rendering.MarkdownDocumentRenderer().render(makeHostileDocument())

        #expect(output.contains("https://example.com/company%20path%281%29%07"))
        #expect(output.contains("https://example.com/profile%20path%281%29%0Anext"))
        #expect(output.contains("/assets/CV%20%28final%29.pdf"))
        #expect(output.contains("https://example.com/evidence%20path%281%29%0A#bad"))
        #expect(output.contains("https://example.com/already%20encoded"))
        #expect(!output.contains("already%2520encoded"))
    }

    @Test("hostile fixture rendering remains deterministic")
    func hostileFixtureRenderingIsDeterministic() {
        let document = makeHostileDocument()
        let renderer = Rendering.MarkdownDocumentRenderer()

        #expect(renderer.render(document) == renderer.render(document))
    }

    private func decode(_ json: String) throws -> CVDocument {
        let data = try #require(json.data(using: .utf8))
        return try JSONDecoder().decode(CVDocument.self, from: data)
    }

    private func index(of needle: String, in haystack: String) throws -> String.Index {
        try #require(haystack.range(of: needle)?.lowerBound)
    }

    private func democvDocument(renderingMode mode: RenderingMode) throws -> CVDocument {
        let fixtureData = try Data(contentsOf: fixtureURL("Examples/democv/cv.json"))
        let document = try JSONDecoder().decode(CVDocument.self, from: fixtureData)

        return CVDocument(
            frontMatter: document.frontMatter,
            cv: document.cv,
            links: document.links,
            publicEvidence: document.publicEvidence,
            rendering: RenderingOptions(
                frontMatterProfile: document.rendering.frontMatterProfile,
                mode: mode,
                recentCompanyCount: document.rendering.recentCompanyCount,
                selectedExperienceIDs: document.rendering.selectedExperienceIDs,
                maxBulletsPerProject: document.rendering.maxBulletsPerProject,
                nestProjectsUnderRoles: document.rendering.nestProjectsUnderRoles,
                compactGroupedSkills: document.rendering.compactGroupedSkills,
                omitEmptySections: document.rendering.omitEmptySections,
            ),
        )
    }

    private func expectedMarkdownFixture(_ fixtureName: String) throws -> String {
        let fixtureStem = fixtureName.replacingOccurrences(of: ".md", with: "")
        let fixtureURL = try #require(Bundle.module.url(forResource: fixtureStem, withExtension: "md"))
        var expected = try String(
            contentsOf: fixtureURL,
            encoding: .utf8,
        )
        if expected.hasSuffix("\n") {
            expected.removeLast()
        }
        return expected
    }

    private func fixtureURL(_ relativePath: String) -> URL {
        let testsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        return testsDirectory
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(relativePath)
    }

    private func occurrenceCount(of needle: String, in haystack: String) -> Int {
        var count = 0
        var searchRange = haystack.startIndex ..< haystack.endIndex

        while let range = haystack.range(of: needle, range: searchRange) {
            count += 1
            searchRange = range.upperBound ..< haystack.endIndex
        }

        return count
    }
}

private func renderedFrontMatter(_ frontMatter: [String: String], profile: FrontMatterProfile) -> String {
    let document = makeMinimalDocument(
        frontMatter: frontMatter,
        rendering: RenderingOptions(frontMatterProfile: profile),
    )
    return Rendering.MarkdownDocumentRenderer().render(document)
}

private func makeFrontMatterProfileDocument(profile: FrontMatterProfile?) -> CVDocument {
    makeMinimalDocument(
        frontMatter: [
            "custom-key": "custom value",
            "date": "2026-06-02",
            "description": "Builds Swift tooling.",
            "draft": "false",
            "layout": "cv",
            "permalink": "/cv/",
            "slug": "demo-cv",
            "tags": "Swift, Linux",
            "title": "Demo CV",
        ],
        rendering: profile.map { RenderingOptions(frontMatterProfile: $0) } ?? .init(),
    )
}

private func makeHostileDocument(
    frontMatter: [String: String] = [
        "slug": "hostile cv",
        "title": "Demo: ---\n# forged",
    ],
    rendering: RenderingOptions = .init(),
) -> CVDocument {
    let period = Period(
        start: .init(month: 1, year: 2024),
        end: .init(month: 6, year: 2026),
    )
    let company = Company(name: "ACME | Labs [evil](x)")
    let role = Role(title: "1. Architect *API*", seniority: .senior)
    let project = makeHostileProject(company: company, role: role, period: period)
    let projectExperience = ProjectExperience(project: project, role: role, period: period)
    let work = WorkExperience(
        company: company,
        role: role,
        period: period,
        projects: [projectExperience],
        isCurrent: true,
    )

    return CVDocument(
        frontMatter: frontMatter,
        cv: makeHostileCV(period: period, work: work),
        links: makeHostileLinks(),
        publicEvidence: makeHostilePublicEvidence(),
        rendering: rendering,
    )
}

private func makeMinimalDocument(
    frontMatter: [String: String] = [:],
    experience: [WorkExperience] = [],
    publicEvidence: [PublicEvidence] = [],
    rendering: RenderingOptions = .init(),
) -> CVDocument {
    CVDocument(
        frontMatter: frontMatter,
        cv: CV(
            name: "Taylor Example",
            title: "Swift Engineer",
            summary: "Builds Swift systems.",
            contactInfo: ContactInfo(
                email: "taylor@example.com",
                phone: "+1 555 010 0106",
                location: "Example City",
            ),
            experience: experience,
            education: [],
            skills: [],
        ),
        publicEvidence: publicEvidence,
        rendering: rendering,
    )
}

private func makeLimitedWorkDocument(rendering: RenderingOptions) -> CVDocument {
    let period = Period(start: .init(month: 1, year: 2024), end: .init(month: 6, year: 2026))
    let visibleCompany = Company(name: "Visible Systems")
    let hiddenCompany = Company(name: "Hidden Systems")
    let role = Role(title: "Engineer", seniority: .senior)
    let visibleProject = Project(
        name: "Visible Project",
        company: visibleCompany,
        descriptions: [
            "First visible project fact.",
            "Second hidden project fact.",
        ],
        techs: [Tech(name: "Swift", category: .language)],
        role: role,
        period: period,
    )
    let visibleExperience = WorkExperience(
        company: visibleCompany,
        role: role,
        period: period,
        projects: [ProjectExperience(project: visibleProject, role: role, period: period)],
    )
    let hiddenExperience = WorkExperience(
        company: hiddenCompany,
        role: role,
        period: period,
        projects: [],
    )

    return makeMinimalDocument(
        experience: [visibleExperience, hiddenExperience],
        rendering: rendering,
    )
}

private func makeSelectedWorkDocument(rendering: RenderingOptions) throws -> CVDocument {
    let role = Role(title: "Engineer", seniority: .senior)
    let recentPeriod = Period(start: .init(month: 4, year: 2026), end: .init(month: 6, year: 2026))
    let selectedPeriod = Period(start: .init(month: 1, year: 2021), end: .init(month: 8, year: 2022))
    let legacyPeriod = Period(start: .init(month: 1, year: 2019), end: .init(month: 12, year: 2020))

    let recentExperience = try WorkExperience(
        id: #require(UUID(uuidString: "00000000-0000-0000-0000-000000000401")),
        company: Company(name: "Recent Hidden Systems"),
        role: role,
        period: recentPeriod,
        projects: [
            ProjectExperience(
                project: Project(
                    name: "Recent Hidden App",
                    company: Company(name: "Recent Hidden Systems"),
                    descriptions: ["Recent but less relevant delivery."],
                    techs: [Tech(name: "Swift", category: .language)],
                    role: role,
                    period: recentPeriod,
                ),
                role: role,
                period: recentPeriod,
            ),
        ],
    )
    let selectedExperience = try WorkExperience(
        id: #require(UUID(uuidString: "00000000-0000-0000-0000-000000000402")),
        company: Company(name: "Selected Platform Lab"),
        role: role,
        period: selectedPeriod,
        projects: [
            ProjectExperience(
                project: Project(
                    name: "Relevant Platform Migration",
                    company: Company(name: "Selected Platform Lab"),
                    descriptions: ["Relevant older platform migration."],
                    techs: [Tech(name: "Swift Package Manager", category: .tool)],
                    role: role,
                    period: selectedPeriod,
                ),
                role: role,
                period: selectedPeriod,
            ),
        ],
    )
    let unselectedExperience = try WorkExperience(
        id: #require(UUID(uuidString: "00000000-0000-0000-0000-000000000403")),
        company: Company(name: "Unselected Legacy Works"),
        role: role,
        period: legacyPeriod,
        projects: [],
    )

    return makeMinimalDocument(
        experience: [recentExperience, selectedExperience, unselectedExperience],
        rendering: rendering,
    )
}

private func makeHostileProject(company: Company, role: Role, period: Period) -> Project {
    Project(
        name: "- Project [link]",
        company: company,
        descriptions: [
            "---",
            "# heading\n- list\n1. Ordered\n+ plus\n| a | b |\n<admin@example.com>\n[text](https://bad)",
        ],
        techs: [Tech(name: "Swift|Table", category: .language)],
        role: role,
        period: period,
        technicalFocus: .init(areas: ["# Architecture", "A|B"], tags: ["-tag", "1. item"]),
    )
}

private func makeHostileCV(period: Period, work: WorkExperience) -> CV {
    CV(
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
            Education(institution: "# University", degree: "MSc", field: "Security|Parsing", period: period),
        ],
        skills: [
            Tech(name: "*OpenAPI*", category: .tool),
            Tech(name: "_internal_", category: .tool),
        ],
    )
}

private func makeHostileLinks() -> DocumentLinks {
    DocumentLinks(
        profiles: [
            Link(label: "[Profile](bad)", url: "https://example.com/profile path(1)\nnext"),
        ],
        downloads: [
            Link(label: "CV (PDF)", url: "/assets/CV (final).pdf"),
            Link(label: "Existing", url: "https://example.com/already%20encoded"),
        ],
        companyURLs: [
            "ACME | Labs [evil](x)": "https://example.com/company path(1)\u{0007}",
        ],
    )
}

private func makeHostilePublicEvidence() -> [PublicEvidence] {
    [
        PublicEvidence(
            title: "Evidence [x](y)",
            kind: .openSource,
            role: "Maintainer",
            summary: "Summary with ---\n# forged",
            url: "https://example.com/evidence path(1)\n#bad",
            technologies: ["Swift|Table", "*OpenAPI*"],
            highlights: ["- shipped", "1. measured"],
            technicalFocus: .init(areas: ["Developer|Tooling"], tags: ["[contracts]"]),
        ),
    ]
}
