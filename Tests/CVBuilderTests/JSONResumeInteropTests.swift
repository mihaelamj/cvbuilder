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

    // MARK: Absent optional dates round-trip absent (no fabricated sentinels)

    @Test("a work entry missing startDate re-exports with startDate still absent")
    func workMissingStartDateRoundTripsAbsent() throws {
        let exported = try reExported(#"{"work":[{"name":"X","position":"Senior Engineer","endDate":"2020-05","summary":"s"}]}"#)

        #expect(!exported.contains("\"startDate\""))
        #expect(exported.contains("\"endDate\" : \"2020-05\""))
        #expect(!exported.contains("0001"))
    }

    @Test("a work entry missing endDate (ongoing) re-exports with endDate still absent")
    func workMissingEndDateRoundTripsAbsent() throws {
        let exported = try reExported(#"{"work":[{"name":"X","position":"Senior Engineer","startDate":"2018-01","summary":"s"}]}"#)

        #expect(exported.contains("\"startDate\" : \"2018-01\""))
        #expect(!exported.contains("\"endDate\""))
        #expect(!exported.contains("0001"))
    }

    @Test("education missing endDate does not copy the start date onto the end")
    func educationMissingEndDateDoesNotCopyStart() throws {
        let exported = try reExported(#"{"education":[{"institution":"U","area":"CS","studyType":"BSc","startDate":"2014-09"}]}"#)

        #expect(exported.contains("\"startDate\" : \"2014-09\""))
        #expect(!exported.contains("\"endDate\""))
    }

    @Test("education missing startDate re-exports with startDate still absent")
    func educationMissingStartDateRoundTripsAbsent() throws {
        let exported = try reExported(#"{"education":[{"institution":"U","area":"CS","studyType":"BSc","endDate":"2018-06"}]}"#)

        #expect(!exported.contains("\"startDate\""))
        #expect(exported.contains("\"endDate\" : \"2018-06\""))
        #expect(!exported.contains("0001"))
    }

    @Test("a project missing startDate re-exports with startDate still absent")
    func projectMissingStartDateRoundTripsAbsent() throws {
        let exported = try reExported(#"{"projects":[{"name":"P","description":"d","endDate":"2021-06"}]}"#)

        #expect(!exported.contains("\"startDate\""))
        #expect(exported.contains("\"endDate\" : \"2021-06\""))
        #expect(!exported.contains("0001"))
    }

    @Test("a project missing endDate re-exports with endDate still absent")
    func projectMissingEndDateRoundTripsAbsent() throws {
        let exported = try reExported(#"{"projects":[{"name":"P","description":"d","startDate":"2019-03"}]}"#)

        #expect(exported.contains("\"startDate\" : \"2019-03\""))
        #expect(!exported.contains("\"endDate\""))
        #expect(!exported.contains("0001"))
    }

    @Test("a document with entirely absent dates emits no fabricated date")
    func entirelyAbsentDatesEmitNoFabricatedDate() throws {
        let exported = try reExported(#"{"work":[{"name":"X","position":"Engineer","summary":"s"}],"education":[{"institution":"U","area":"CS","studyType":"BSc"}]}"#)

        #expect(!exported.contains("\"startDate\""))
        #expect(!exported.contains("\"endDate\""))
        #expect(!exported.contains("0001"))
    }

    // MARK: Same-name employer URLs and profile mapping (#117)

    @Test("same-name employers with different URLs do not corrupt each other")
    func sameNameEmployerConflictingURLsAreDropped() throws {
        let json = #"{"work":[{"name":"X","position":"Engineer","url":"https://first.com","summary":"a"},{"name":"X","position":"Engineer","url":"https://second.com","summary":"b"}]}"#
        let document = try CVDocument(jsonResume: decodeResume(json))

        // Ambiguous URL is dropped rather than applied to both entries.
        #expect(document.links.companyURLs["X"] == nil)

        let exported = try reExported(json)
        #expect(!exported.contains("first.com"))
        #expect(!exported.contains("second.com"))
    }

    @Test("same-name employers sharing one URL keep it")
    func sameNameEmployerSharedURLIsKept() throws {
        let json = #"{"work":[{"name":"X","position":"Engineer","url":"https://shared.com","summary":"a"},{"name":"X","position":"Engineer","url":"https://shared.com","summary":"b"}]}"#
        let document = try CVDocument(jsonResume: decodeResume(json))

        #expect(document.links.companyURLs["X"] == "https://shared.com")
    }

    @Test("LinkedIn and GitHub profiles re-emit first in canonical order (documented)")
    func profilesReorderToCanonical() throws {
        let json = #"{"basics":{"name":"N","profiles":[{"network":"GitHub","url":"https://gh"},{"network":"LinkedIn","url":"https://li"},{"network":"Mastodon","url":"https://m"}]}}"#
        let exported = try JSONResume(cvDocument: CVDocument(jsonResume: decodeResume(json)))

        #expect(exported.basics.profiles.map(\.network) == ["LinkedIn", "GitHub", "Mastodon"])
    }

    @Test("a duplicate LinkedIn profile is dropped, keeping the first (documented)")
    func duplicateProfileIsDropped() throws {
        let json = #"{"basics":{"name":"N","profiles":[{"network":"LinkedIn","url":"https://li1"},{"network":"LinkedIn","url":"https://li2"}]}}"#
        let document = try CVDocument(jsonResume: decodeResume(json))

        #expect(document.cv.contactInfo.linkedIn?.absoluteString == "https://li1")

        let exported = JSONResume(cvDocument: document)
        #expect(exported.basics.profiles.count(where: { $0.network == "LinkedIn" }) == 1)
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

    @Test("seniority matches case-insensitively", arguments: [
        "senior iOS Engineer", "SENIOR iOS Engineer", "Senior iOS Engineer",
    ])
    func seniorityMatchesCaseInsensitively(_ position: String) {
        #expect(JSONResumeSeniority.split(position: position) == (.senior, "iOS Engineer"))
    }

    @Test("a single seniority word and an empty position carry no inferred seniority")
    func singleWordAndEmptyPositionsDefaultToMid() {
        #expect(JSONResumeSeniority.split(position: "Senior") == (.mid, "Senior"))
        #expect(JSONResumeSeniority.split(position: "Principal") == (.mid, "Principal"))
        #expect(JSONResumeSeniority.split(position: "") == (.mid, ""))
    }

    @Test("position reconstruction omits the prefix for the mid default")
    func positionReconstruction() {
        #expect(JSONResumeSeniority.position(seniority: .senior, title: "iOS Engineer") == "Senior iOS Engineer")
        #expect(JSONResumeSeniority.position(seniority: .mid, title: "iOS Engineer") == "iOS Engineer")
        #expect(JSONResumeSeniority.position(seniority: .mid, title: "") == "")
    }

    @Test("positions without a recognized seniority round-trip without a fabricated Mid")
    func positionsRoundTripWithoutFabricatedMid() throws {
        let noSeniority = try reExported(#"{"work":[{"name":"X","position":"iOS Engineer","summary":"s"}]}"#)
        #expect(noSeniority.contains("\"position\" : \"iOS Engineer\""))
        #expect(!noSeniority.contains("Mid"))

        let singleWord = try reExported(#"{"work":[{"name":"X","position":"Principal","summary":"s"}]}"#)
        #expect(singleWord.contains("\"position\" : \"Principal\""))
        #expect(!singleWord.contains("Mid"))

        let recognized = try reExported(#"{"work":[{"name":"X","position":"Senior iOS Engineer","summary":"s"}]}"#)
        #expect(recognized.contains("\"position\" : \"Senior iOS Engineer\""))
    }

    @Test("an absent position re-exports absent, with no Mid prefix or trailing space")
    func absentPositionRoundTripsAbsent() throws {
        let exported = try reExported(#"{"work":[{"name":"X","summary":"s"}]}"#)

        #expect(!exported.contains("\"position\""))
        #expect(!exported.contains("Mid"))
    }

    @Test("a case-different seniority re-exports in canonical casing (documented normalization)")
    func caseInsensitiveSeniorityNormalizesCasing() throws {
        let exported = try reExported(#"{"work":[{"name":"X","position":"senior engineer","summary":"s"}]}"#)

        #expect(exported.contains("\"position\" : \"Senior engineer\""))
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

    private func decodeResume(_ jsonResumeText: String) throws -> JSONResume {
        try JSONDecoder().decode(JSONResume.self, from: Data(jsonResumeText.utf8))
    }

    private func reExported(_ jsonResumeText: String) throws -> String {
        try normalizedJSONResume(for: CVDocument(jsonResume: decodeResume(jsonResumeText)))
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
