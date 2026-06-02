@testable import CVBuilder
import Foundation
import Testing

/// Enforcing tests for the enrichment-pass-2 research rules R16-R19
/// (see <doc:ProofMatrix>). Each asserts the rule's core invariant against the
/// canonical renderer so policy drift fails the build.
@Suite("Research rule enforcement (R16-R19)")
struct ResearchRuleEnforcementTests {
    private let renderer = Rendering.MarkdownDocumentRenderer()

    // MARK: - R16 accessible, semantically-structured output

    @Test("accessible heading structure has a single title and no skipped levels")
    func accessibleHeadingStructure() throws {
        let output = try renderer.render(demoDocument())

        let headingLevels = output
            .split(separator: "\n", omittingEmptySubsequences: false)
            .compactMap(headingLevel)

        // Exactly one top-level `#` title.
        #expect(headingLevels.count(where: { $0 == 1 }) == 1)

        // Heading levels never skip downward (no `#` -> `###`).
        var deepest = 0
        for level in headingLevels {
            #expect(level <= deepest + 1)
            deepest = level
        }

        // No tables/columns for core facts: no GFM table delimiter row, no HTML
        // table, and no pipe-delimited multi-column row.
        #expect(!output.contains("|---"))
        #expect(!output.contains("---|"))
        #expect(!output.lowercased().contains("<table"))
        #expect(!output.split(separator: "\n").contains { isPipeTableRow($0) })
    }

    // MARK: - R17 date/period rendering never auto-computes gaps or durations

    @Test("date rendering emits no auto-computed gaps or durations")
    func noAutoComputedGapsOrDurations() {
        let role = Role(title: "Engineer", seniority: .senior)
        let early = workExperience("Acme", role: role, start: (1, 2016), end: (12, 2018))
        let late = workExperience("Globex", role: role, start: (1, 2022), end: (6, 2024))
        let document = CVDocument(cv: cv(experience: [late, early]))

        let output = renderer.render(document).lowercased()

        // The renderer never derives a between-role gap or a duration token.
        for marker in ["gap", "yr)", "yrs", "years)", "year)", "months)", "duration", "break", "hiatus", "unemploy"] {
            #expect(!output.contains(marker))
        }
        // The dates themselves still render.
        #expect(renderer.render(document).contains("Jan 2016 - Dec 2018"))
    }

    @Test("the optional duration-period mode renders whole-year tenure on request")
    func durationPeriodModeRendersTenure() {
        let role = Role(title: "Engineer", seniority: .senior)
        let work = workExperience("Acme", role: role, start: (1, 2021), end: (1, 2024))
        let document = CVDocument(cv: cv(experience: [work]), rendering: RenderingOptions(useDurationPeriods: true))

        let output = renderer.render(document)

        // Opt-in duration replaces the date range; it is derived only from the
        // typed start and end, not from a gap between roles.
        #expect(output.contains("3 yrs"))
        #expect(!output.contains("Jan 2021 - Jan 2024"))
    }

    // MARK: - R18 accomplishment content renders faithfully, never inflated

    @Test("accomplishment content renders verbatim without fabricated metrics")
    func accomplishmentContentRendersVerbatim() throws {
        let fact = "Maintained the release pipeline and documentation."
        let role = Role(title: "Engineer", seniority: .senior)
        let project = Project(
            name: "Tooling",
            company: Company(name: "Acme"),
            descriptions: [],
            accomplishments: [fact],
            techs: [],
            role: role,
            period: Period(start: .init(month: 1, year: 2023), end: .init(month: 6, year: 2023)),
        )
        let work = WorkExperience(
            company: Company(name: "Acme"),
            role: role,
            period: project.period,
            projects: [ProjectExperience(project: project, role: role, period: project.period)],
        )
        let output = renderer.render(CVDocument(cv: cv(experience: [work])))

        // The supplied accomplishment renders verbatim.
        #expect(output.contains(fact))
        // No fabricated quantification is injected: the input carries no percent
        // sign anywhere, and the rendered accomplishment line carries no digits
        // (the renderer adds no metrics or superlatives of its own).
        #expect(!output.contains("%"))
        let factLine = try #require(output.split(separator: "\n").first { $0.contains("Maintained the release pipeline") })
        let factLineHasDigit = factLine.contains(where: \.isNumber)
        #expect(!factLineHasDigit)
    }

    @Test("project accomplishments decode from JSON and render verbatim")
    func accomplishmentsDecodeAndRender() throws {
        let json = """
        {
          "cv": {
            "name": "A", "title": "T", "summary": "S",
            "contactInfo": { "email": "a@b.c", "phone": "+1", "location": "X" },
            "experience": [{
              "company": { "name": "C" },
              "role": { "title": "Engineer", "seniority": "Senior" },
              "period": { "start": { "month": 1, "year": 2023 }, "end": { "month": 6, "year": 2023 } },
              "projects": [{
                "project": {
                  "name": "P", "company": { "name": "C" },
                  "role": { "title": "Engineer", "seniority": "Senior" },
                  "period": { "start": { "month": 1, "year": 2023 }, "end": { "month": 6, "year": 2023 } },
                  "accomplishments": ["Shipped the release tooling."]
                },
                "role": { "title": "Engineer", "seniority": "Senior" },
                "period": { "start": { "month": 1, "year": 2023 }, "end": { "month": 6, "year": 2023 } }
              }]
            }]
          }
        }
        """
        let document = try JSONDecoder().decode(CVDocument.self, from: Data(json.utf8))
        let project = try #require(document.cv.experience.first?.projects.first?.project)

        #expect(project.accomplishments == ["Shipped the release tooling."])
        #expect(renderer.render(document).contains("Shipped the release tooling."))
    }

    // MARK: - R19 localized output is taxonomy-mappable and origin-safe

    @Test("localized output keeps a fixed name slot, stable structure, and no origin fields")
    func localizedOutputIsStableAndOriginSafe() throws {
        let base = try demoDocument()
        let englishOutput = renderer.render(localized(base, to: .english))
        let germanOutput = renderer.render(localized(base, to: .german))

        // The name occupies the same fixed top-of-document slot in both locales.
        let englishTitle = englishOutput.split(separator: "\n").first { $0.hasPrefix("# ") }
        let germanTitle = germanOutput.split(separator: "\n").first { $0.hasPrefix("# ") }
        #expect(englishTitle == "# \(base.cv.name)")
        #expect(germanTitle == englishTitle)

        // The heading-level structure is locale-independent (canonical tokens
        // localize, the structure does not).
        let englishLevels = englishOutput.split(separator: "\n", omittingEmptySubsequences: false).compactMap(headingLevel)
        let germanLevels = germanOutput.split(separator: "\n", omittingEmptySubsequences: false).compactMap(headingLevel)
        #expect(englishLevels == germanLevels)

        // No origin-revealing field is rendered by default in either locale
        // (English and German labels checked).
        let originTokens = [
            "nationality", "nationalität", "date of birth", "birthdate", "geburtsdatum",
            "marital", "familienstand", "gender", "geschlecht",
        ]
        for output in [englishOutput.lowercased(), germanOutput.lowercased()] {
            for token in originTokens {
                #expect(!output.contains(token))
            }
        }
    }

    // MARK: - Helpers

    /// Whether a line is a pipe-delimited table row (two or more unescaped
    /// pipes). The renderer escapes data pipes, so a real `| a | b |` row only
    /// appears if core facts were laid out as columns.
    private func isPipeTableRow(_ line: Substring) -> Bool {
        var unescapedPipes = 0
        var previous: Character?
        for character in line {
            if character == "|", previous != "\\" {
                unescapedPipes += 1
            }
            previous = character
        }
        return unescapedPipes >= 2
    }

    private func headingLevel(_ line: Substring) -> Int? {
        let hashes = line.prefix { $0 == "#" }.count
        guard hashes >= 1, line.dropFirst(hashes).hasPrefix(" ") else {
            return nil
        }
        return hashes
    }

    private func demoDocument() throws -> CVDocument {
        let data = try Data(contentsOf: fixtureURL("Examples/democv/cv.json"))
        return try JSONDecoder().decode(CVDocument.self, from: data)
    }

    private func localized(_ document: CVDocument, to locale: RenderingLocale) -> CVDocument {
        let rendering = document.rendering
        return CVDocument(
            frontMatter: document.frontMatter,
            cv: document.cv,
            links: document.links,
            publicEvidence: document.publicEvidence,
            rendering: RenderingOptions(
                frontMatterProfile: rendering.frontMatterProfile,
                mode: rendering.mode,
                locale: locale,
                recentCompanyCount: rendering.recentCompanyCount,
                selectedExperienceIDs: rendering.selectedExperienceIDs,
                maxBulletsPerProject: rendering.maxBulletsPerProject,
                nestProjectsUnderRoles: rendering.nestProjectsUnderRoles,
                compactGroupedSkills: rendering.compactGroupedSkills,
                omitEmptySections: rendering.omitEmptySections,
            ),
        )
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

    private func workExperience(
        _ company: String,
        role: Role,
        start: (month: Int, year: Int),
        end: (month: Int, year: Int),
    ) -> WorkExperience {
        WorkExperience(
            company: Company(name: company),
            role: role,
            period: Period(start: .init(month: start.month, year: start.year), end: .init(month: end.month, year: end.year)),
            projects: [],
        )
    }

    private func fixtureURL(_ relativePath: String) -> URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(relativePath)
    }
}
