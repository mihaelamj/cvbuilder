@testable import CVBuilder
import Foundation
import Testing

@Suite("CVDocument JSON ergonomics")
struct CVDocumentJSONErgonomicsTests {
    @Test("minimal handwritten JSON can omit UUIDs and default arrays")
    func decodesMinimalHandwrittenDocument() throws {
        let document = try decode(minimalDocumentJSON)

        #expect(document.frontMatter.isEmpty)
        #expect(document.links == DocumentLinks())
        #expect(document.publicEvidence.isEmpty)
        #expect(document.rendering == RenderingOptions())
        #expect(document.cv.experience.isEmpty)
        #expect(document.cv.education.isEmpty)
        #expect(document.cv.skills.isEmpty)
        #expect(document.cv.id.uuidString.count == 36)
        try expectNormalizedRoundTrip(document)
    }

    @Test("full JSON preserves explicit IDs and collection values")
    func preservesExplicitValuesInFullDocument() throws {
        let document = try decode(fullDocumentJSON)
        let firstWork = try #require(document.cv.experience.first)
        let firstProjectExperience = try #require(firstWork.projects.first)
        let firstProject = firstProjectExperience.project
        let firstEvidence = try #require(document.publicEvidence.first)
        let cvID = try uuid("00000000-0000-0000-0000-000000000201")
        let workID = try uuid("00000000-0000-0000-0000-000000000202")
        let companyID = try uuid("00000000-0000-0000-0000-000000000203")
        let roleID = try uuid("00000000-0000-0000-0000-000000000204")
        let projectExperienceID = try uuid("00000000-0000-0000-0000-000000000205")
        let projectID = try uuid("00000000-0000-0000-0000-000000000206")
        let projectTechID = try uuid("00000000-0000-0000-0000-000000000207")
        let educationID = try uuid("00000000-0000-0000-0000-000000000208")
        let skillID = try uuid("00000000-0000-0000-0000-000000000209")
        let evidenceID = try uuid("00000000-0000-0000-0000-000000000210")

        #expect(document.cv.id == cvID)
        #expect(firstWork.id == workID)
        #expect(firstWork.company.id == companyID)
        #expect(firstWork.role.id == roleID)
        #expect(firstProjectExperience.id == projectExperienceID)
        #expect(firstProject.id == projectID)
        #expect(firstProject.techs.first?.id == projectTechID)
        #expect(document.cv.education.first?.id == educationID)
        #expect(document.cv.skills.first?.id == skillID)
        #expect(firstEvidence.id == evidenceID)
        #expect(document.frontMatter["slug"] == "demo-cv")
        #expect(document.links.profiles.first?.label == "GitHub")
        #expect(document.links.companyURLs["Example Systems"] == "https://example.com/company")
        #expect(firstProject.descriptions == ["Built a Swift package."])
        #expect(firstEvidence.highlights == ["Kept releases documented."])
        try expectNormalizedRoundTrip(document)
    }

    @Test("partially omitted nested collections decode as natural defaults")
    func defaultsNestedOmittedCollections() throws {
        let document = try decode(partialDocumentJSON)

        let work = try #require(document.cv.experience.first)
        let education = try #require(document.cv.education.first)
        let skill = try #require(document.cv.skills.first)
        let evidence = try #require(document.publicEvidence.first)

        #expect(work.projects.isEmpty)
        #expect(work.isCurrent == false)
        #expect(work.technicalFocus?.areas == ["Architecture"])
        #expect(work.technicalFocus?.tags == [])
        #expect(document.links.profiles.isEmpty)
        #expect(document.links.downloads.first?.url == "/cv.md")
        #expect(document.links.companyURLs.isEmpty)
        #expect(evidence.technologies.isEmpty)
        #expect(evidence.highlights.isEmpty)
        #expect(evidence.technicalFocus?.areas == [])
        #expect(evidence.technicalFocus?.tags == ["architecture"])
        #expect(document.rendering.mode == .earlyCareerTechnical)
        #expect(document.rendering.nestProjectsUnderRoles)
        #expect(document.rendering.compactGroupedSkills)
        #expect(document.rendering.omitEmptySections)
        #expect(work.id.uuidString.count == 36)
        #expect(work.company.id.uuidString.count == 36)
        #expect(work.role.id.uuidString.count == 36)
        #expect(education.id.uuidString.count == 36)
        #expect(skill.id.uuidString.count == 36)
        #expect(evidence.id.uuidString.count == 36)
        try expectNormalizedRoundTrip(document)
    }

    @Test("project-level omitted collections decode as empty")
    func defaultsProjectCollections() throws {
        let document = try decode(projectCollectionsDocumentJSON)
        let work = try #require(document.cv.experience.first)
        let projectExperience = try #require(work.projects.first)
        let project = projectExperience.project

        #expect(project.descriptions.isEmpty)
        #expect(project.techs.isEmpty)
        #expect(project.urls == nil)
        #expect(project.isCurrent == false)
        #expect(project.id.uuidString.count == 36)
        #expect(projectExperience.id.uuidString.count == 36)
        try expectNormalizedRoundTrip(document)
    }

    @Test("explicit null IDs are rejected instead of synthesized")
    func rejectsNullID() throws {
        try expectDecodeFails(nullIDDocumentJSON)
    }

    @Test("explicit null collections are rejected instead of defaulted")
    func rejectsNullCollection() throws {
        try expectDecodeFails(nullCollectionDocumentJSON)
    }

    private func decode(_ json: String) throws -> CVDocument {
        let data = try #require(json.data(using: .utf8))
        return try JSONDecoder().decode(CVDocument.self, from: data)
    }

    private func expectNormalizedRoundTrip(_ document: CVDocument) throws {
        let encoded = try JSONEncoder().encode(document)
        let decoded = try JSONDecoder().decode(CVDocument.self, from: encoded)

        #expect(decoded == document)
    }

    private func expectDecodeFails(_ json: String) throws {
        let data = try #require(json.data(using: .utf8))

        do {
            _ = try JSONDecoder().decode(CVDocument.self, from: data)
            Issue.record("Expected CVDocument decoding to fail")
        } catch is DecodingError {
            return
        } catch {
            Issue.record("Expected DecodingError, got \(error)")
        }
    }

    private func uuid(_ value: String) throws -> UUID {
        try #require(UUID(uuidString: value))
    }
}
