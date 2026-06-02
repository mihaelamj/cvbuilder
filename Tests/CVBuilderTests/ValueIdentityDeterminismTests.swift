@testable import CVBuilder
import Foundation
import Testing

/// Regression coverage for the synthesized-`id` cluster (#119, #114, #131): the
/// determinism contract for normalized JSON and the semantic value identity of
/// `Tech` and `Company`.
@Suite("Value identity and determinism")
struct ValueIdentityDeterminismTests {
    // MARK: - #119 normalized-JSON determinism

    @Test("documents that omit IDs normalize to byte-identical JSON across runs")
    func omittedIDsNormalizeDeterministically() throws {
        let first = try normalizedJSON(for: decode(omittedIDDocumentJSON))
        let second = try normalizedJSON(for: decode(omittedIDDocumentJSON))

        #expect(first == second)
    }

    @Test("omitted IDs are not synthesized into normalized output")
    func omittedIDsStayOmittedInOutput() throws {
        let output = try normalizedJSON(for: decode(omittedIDDocumentJSON))

        #expect(!output.contains("\"id\""))
    }

    @Test("explicit IDs round-trip unchanged in normalized output")
    func explicitIDsArePreserved() throws {
        let document = try decode(explicitIDDocumentJSON)
        let output = try normalizedJSON(for: document)

        #expect(output.contains("\"00000000-0000-0000-0000-000000000901\""))
    }

    // MARK: - #114 skill deduplication

    @Test("skills dedupe on name and category across projects with distinct IDs")
    func skillsDedupeOnSemanticKey() {
        let swiftLanguage = Tech(name: "Swift", category: .language)
        let swiftLanguageAgain = Tech(name: "Swift", category: .language)
        let swiftFramework = Tech(name: "Swift", category: .framework)

        let cv = CV.create(
            name: "Test",
            title: "Engineer",
            summary: "Summary",
            contactInfo: contactInfo,
            education: [],
            projects: [
                project(company: "Acme", techs: [swiftLanguage]),
                project(company: "Acme", techs: [swiftLanguageAgain, swiftFramework]),
            ],
        )

        #expect(cv.skills.count == 2)
        #expect(cv.skills.count(where: { $0.name == "Swift" && $0.category == .language }) == 1)
        #expect(cv.skills.count(where: { $0.name == "Swift" && $0.category == .framework }) == 1)
    }

    @Test("identical skills with distinct IDs collapse in a Set")
    func techIdentityIgnoresID() {
        let a = Tech(id: UUID(), name: "Swift", category: .language)
        let b = Tech(id: UUID(), name: "Swift", category: .language)

        #expect(a == b)
        #expect(Set([a, b]).count == 1)
    }

    // MARK: - #131 company grouping

    @Test("projects at the same-named company merge into one experience entry")
    func sameNameCompaniesMergeIntoOneExperience() {
        let cv = CV.create(
            name: "Test",
            title: "Engineer",
            summary: "Summary",
            contactInfo: contactInfo,
            education: [],
            projects: [
                project(company: "Acme", name: "Alpha"),
                project(company: "Acme", name: "Beta"),
                project(company: "Acme", name: "Gamma"),
            ],
        )

        #expect(cv.experience.count == 1)
        #expect(cv.experience.first?.projects.count == 3)
    }

    @Test("companies with the same name are equal regardless of ID")
    func companyIdentityIgnoresID() {
        let a = Company(id: UUID(), name: "Acme")
        let b = Company(id: UUID(), name: "Acme")

        #expect(a == b)
        #expect(Set([a, b]).count == 1)
    }

    // MARK: - Helpers

    private let contactInfo = ContactInfo(
        email: "a@b.c",
        phone: "+100000000",
        location: "Somewhere",
    )

    private func project(
        company: String,
        name: String = "Project",
        techs: [Tech] = [],
    ) -> Project {
        Project(
            name: name,
            company: Company(name: company),
            descriptions: [],
            techs: techs,
            role: Role(title: "Engineer", seniority: .senior),
            period: Period(
                start: .init(month: 1, year: 2020),
                end: .init(month: 1, year: 2021),
            ),
        )
    }

    private func decode(_ json: String) throws -> CVDocument {
        let data = try #require(json.data(using: .utf8))
        return try JSONDecoder().decode(CVDocument.self, from: data)
    }

    private func normalizedJSON(for document: CVDocument) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(document)
        return try #require(String(data: data, encoding: .utf8))
    }
}

private let omittedIDDocumentJSON = """
{
  "cv": {
    "name": "A",
    "title": "T",
    "summary": "S",
    "contactInfo": { "email": "a@b.c", "phone": "+100000000", "location": "Somewhere" },
    "skills": [{ "name": "Swift", "category": "language" }]
  }
}
"""

private let explicitIDDocumentJSON = """
{
  "cv": {
    "id": "00000000-0000-0000-0000-000000000901",
    "name": "A",
    "title": "T",
    "summary": "S",
    "contactInfo": { "email": "a@b.c", "phone": "+100000000", "location": "Somewhere" }
  }
}
"""
