@testable import CVBuilder
import Foundation
import Testing

@Suite("Rendered-output localization")
struct LocalizationTests {
    @Test("German locale renders to the checked-in golden Markdown")
    func germanLocaleRendersGolden() throws {
        let document = try loadDocument("Tests/CVBuilderTests/Fixtures/Localization/german.json")
        let output = Rendering.MarkdownDocumentRenderer().render(document)
        let golden = try fixtureText("Tests/CVBuilderTests/Fixtures/Localization/german.md")

        #expect(document.rendering.locale == .german)
        #expect(golden == "\(output)\n")
    }

    @Test("German output uses German labels and month names, not English")
    func germanOutputIsLocalized() throws {
        let document = try loadDocument("Tests/CVBuilderTests/Fixtures/Localization/german.json")
        let output = Rendering.MarkdownDocumentRenderer().render(document)

        for heading in ["## Kontakt", "## Berufserfahrung", "## Ausbildung", "## Öffentliche Nachweise", "## Kenntnisse"] {
            #expect(output.contains(heading))
        }
        #expect(output.contains("E-Mail:"))
        #expect(output.contains("Rolle:"))
        #expect(output.contains("Technologien:"))
        #expect(output.contains("Mär 2024 - Heute"))
        #expect(output.contains("Art: Open Source"))
        #expect(output.contains("Sprachen: Swift"))

        for englishLabel in ["## Contact", "## Experience", "## Skills", "Email:", "Role:", "Technologies:", "Present"] {
            #expect(!output.contains(englishLabel))
        }
    }

    @Test("locale only changes labels, never the document structure")
    func localeChangesLabelsNotStructure() throws {
        let document = try loadDocument("Tests/CVBuilderTests/Fixtures/Localization/german.json")
        let englishDocument = withLocale(.english, on: document)
        let germanDocument = withLocale(.german, on: document)

        let englishOutput = Rendering.MarkdownDocumentRenderer().render(englishDocument)
        let germanOutput = Rendering.MarkdownDocumentRenderer().render(germanDocument)

        // Same number of lines and same heading levels: only the label text differs.
        let englishLines = englishOutput.split(separator: "\n", omittingEmptySubsequences: false)
        let germanLines = germanOutput.split(separator: "\n", omittingEmptySubsequences: false)
        #expect(englishLines.count == germanLines.count)

        #expect(englishOutput.contains("## Contact"))
        #expect(englishOutput.contains("Present"))
        #expect(germanOutput.contains("## Kontakt"))
        #expect(englishOutput != germanOutput)
    }

    @Test("default English output is unchanged when locale is omitted")
    func defaultLocaleIsEnglish() throws {
        let json = """
        {
          "cv": {
            "name": "Taylor Example",
            "title": "Senior iOS Developer",
            "summary": "Builds Swift applications and developer tools.",
            "contactInfo": {
              "email": "taylor@example.com",
              "phone": "+1 555 010 0101",
              "location": "Example City"
            }
          }
        }
        """
        let document = try JSONDecoder().decode(CVDocument.self, from: Data(json.utf8))
        let output = Rendering.MarkdownDocumentRenderer().render(document)

        #expect(document.rendering.locale == .english)
        #expect(output.contains("## Contact"))
        #expect(!output.contains("## Kontakt"))
    }

    @Test("locale round-trips through normalized JSON")
    func localeRoundTripsThroughJSON() throws {
        let options = RenderingOptions(locale: .german)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(options)
        let decoded = try JSONDecoder().decode(RenderingOptions.self, from: data)

        #expect(decoded.locale == .german)
        #expect(String(data: data, encoding: .utf8)?.contains("\"locale\":\"de\"") == true)
    }

    @Test("each locale resolves a complete, distinct label set")
    func localesResolveLabels() {
        #expect(RenderingLocale.english.labels.present == "Present")
        #expect(RenderingLocale.german.labels.present == "Heute")
        #expect(RenderingLocale.german.labels.monthNames.count == 12)
        #expect(RenderingLocale.german.labels.monthNames[2] == "Mär")
        #expect(RenderingLocale.allCases.map(\.rawValue) == ["en", "de"])
    }

    private func withLocale(_ locale: RenderingLocale, on document: CVDocument) -> CVDocument {
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

    private func loadDocument(_ relativePath: String) throws -> CVDocument {
        try JSONDecoder().decode(CVDocument.self, from: Data(contentsOf: fixtureURL(relativePath)))
    }

    private func fixtureText(_ relativePath: String) throws -> String {
        try String(contentsOf: fixtureURL(relativePath), encoding: .utf8)
    }

    private func fixtureURL(_ relativePath: String) -> URL {
        let testsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        return testsDirectory
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(relativePath)
    }
}
