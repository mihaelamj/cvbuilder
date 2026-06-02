@testable import CVBuilder
import Foundation
import Testing

@Suite("JSON Resume interop")
struct JSONResumeInteropTests {
    // MARK: Round trip (E ∘ I = identity on the supported subset)

    @Test("JSON Resume round-trips byte-for-byte through CVDocument")
    func jsonResumeRoundTripsByteForByte() throws {
        let original = try fixtureText("Tests/CVBuilderTests/Fixtures/JSONResume/roundtrip.json")

        let resume = try JSONDecoder().decode(JSONResume.self, from: Data(original.utf8))
        let document = CVDocument(jsonResume: resume)
        let reExported = try normalizedJSONResume(for: document)

        #expect(reExported == trimmedTrailingNewline(original))
    }

    // MARK: Import a real-world sample and render deterministic Markdown

    @Test("real JSON Resume sample imports and renders deterministic Markdown")
    func sampleImportsAndRendersDeterministicMarkdown() throws {
        let resume = try loadResume("Tests/CVBuilderTests/Fixtures/JSONResume/sample.json")
        let document = CVDocument(jsonResume: resume)
        let output = Rendering.MarkdownDocumentRenderer().render(document)
        let golden = try fixtureText("Tests/CVBuilderTests/Fixtures/JSONResume/sample.md")

        #expect(golden == "\(output)\n")
    }

    @Test("sample import applies the documented mapping rules")
    func sampleImportAppliesDocumentedMappingRules() throws {
        let resume = try loadResume("Tests/CVBuilderTests/Fixtures/JSONResume/sample.json")
        let document = CVDocument(jsonResume: resume)

        // Seniority inferred from the leading word and stripped from the title.
        let lead = try #require(document.cv.experience.first)
        #expect(lead.role.seniority == .senior)
        #expect(lead.role.title == "iOS Engineer")

        // A position with no recognized seniority word defaults to .mid.
        let second = document.cv.experience[1]
        #expect(second.role.seniority == .mid)
        #expect(second.role.title == "Backend Engineer")

        // Structured location is composed into a single string.
        #expect(document.cv.contactInfo.location == "Example City, Example Region, EX")

        // LinkedIn and GitHub become typed contact links; others become document links.
        #expect(document.cv.contactInfo.linkedIn?.absoluteString == "https://example.com/linkedin")
        #expect(document.cv.contactInfo.github?.absoluteString == "https://example.com/github")
        #expect(document.links.profiles.map(\.label) == ["Mastodon"])

        // Keyword skills expand into one Tech per keyword; group names drop.
        #expect(document.cv.skills.map(\.name) == ["Swift", "Objective-C", "OpenAPI", "GitHub Actions"])

        // Year-only education dates default the month to January.
        let education = try #require(document.cv.education.first)
        #expect(education.period.start == Period.SimpleDate(month: 1, year: 2014))

        // JSON Resume projects become public evidence.
        let evidence = try #require(document.publicEvidence.first)
        #expect(evidence.kind == .openSource)
        #expect(evidence.title == "Contract Tooling")
        #expect(evidence.role == "Maintainer")
    }

    // MARK: Export a CVDocument to a schema-valid JSON Resume

    @Test("CVDocument exports to the golden JSON Resume document")
    func cvDocumentExportsToGoldenJSONResume() throws {
        let document = try loadDocument("Tests/CVBuilderTests/Fixtures/Documents/earlyCareerTechnical.json")
        let exported = try normalizedJSONResume(for: document)
        let golden = try fixtureText("Tests/CVBuilderTests/Fixtures/JSONResume/exported.json")

        #expect(exported == trimmedTrailingNewline(golden))
    }

    @Test("exported JSON Resume decodes as a valid JSON Resume document")
    func exportedJSONResumeIsSchemaValid() throws {
        let document = try loadDocument("Tests/CVBuilderTests/Fixtures/Documents/earlyCareerTechnical.json")
        let resume = JSONResume(cvDocument: document)
        let data = try JSONEncoder().encode(resume)

        let decoded = try JSONDecoder().decode(JSONResume.self, from: data)
        #expect(decoded == resume)
        #expect(!decoded.basics.name.isEmpty)
        #expect(!decoded.work.isEmpty)
    }

    @Test("export introduces no scoring, fit, or demographic fields")
    func exportIntroducesNoProhibitedFields() throws {
        let document = try loadDocument("Tests/CVBuilderTests/Fixtures/Documents/earlyCareerTechnical.json")
        let exported = try normalizedJSONResume(for: document).lowercased()

        for term in ["\"score\"", "\"fit\"", "\"rank\"", "\"image\"", "\"photo\"", "\"personality\"", "\"birthdate\""] {
            #expect(!exported.contains(term))
        }
    }

    // MARK: Date and seniority units

    @Test("JSON Resume date parsing drops day and defaults the month", arguments: [
        ("2025-09-15", Period.SimpleDate(month: 9, year: 2025)),
        ("2025-09", Period.SimpleDate(month: 9, year: 2025)),
        ("2025", Period.SimpleDate(month: 1, year: 2025)),
    ])
    func jsonResumeDateParsing(input: String, expected: Period.SimpleDate) {
        #expect(JSONResumeDate.simpleDate(from: input) == expected)
    }

    @Test("empty or unparseable JSON Resume dates return nil")
    func emptyDatesReturnNil() {
        #expect(JSONResumeDate.simpleDate(from: "") == nil)
        #expect(JSONResumeDate.simpleDate(from: "not-a-date") == nil)
    }

    @Test("JSON Resume dates render in canonical YYYY-MM form")
    func datesRenderCanonically() {
        #expect(JSONResumeDate.string(from: Period.SimpleDate(month: 9, year: 2025)) == "2025-09")
        #expect(JSONResumeDate.string(from: Period.SimpleDate(month: 12, year: 2018)) == "2018-12")
    }

    @Test("seniority is inferred from the leading position word and stripped")
    func seniorityInference() {
        #expect(JSONResumeSeniority.split(position: "Senior iOS Engineer") == (.senior, "iOS Engineer"))
        #expect(JSONResumeSeniority.split(position: "Lead Backend Engineer") == (.lead, "Backend Engineer"))
        #expect(JSONResumeSeniority.split(position: "iOS Engineer") == (.mid, "iOS Engineer"))
        #expect(JSONResumeSeniority.split(position: "Engineer") == (.mid, "Engineer"))
    }

    // MARK: Helpers

    private func loadResume(_ relativePath: String) throws -> JSONResume {
        try JSONDecoder().decode(JSONResume.self, from: Data(contentsOf: fixtureURL(relativePath)))
    }

    private func loadDocument(_ relativePath: String) throws -> CVDocument {
        try JSONDecoder().decode(CVDocument.self, from: Data(contentsOf: fixtureURL(relativePath)))
    }

    private func fixtureText(_ relativePath: String) throws -> String {
        try String(contentsOf: fixtureURL(relativePath), encoding: .utf8)
    }

    private func normalizedJSONResume(for document: CVDocument) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(JSONResume(cvDocument: document))
        return try #require(String(data: data, encoding: .utf8))
    }

    private func trimmedTrailingNewline(_ string: String) -> String {
        guard string.hasSuffix("\n") else {
            return string
        }

        return String(string.dropLast())
    }

    private func fixtureURL(_ relativePath: String) -> URL {
        let testsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        return testsDirectory
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(relativePath)
    }
}
