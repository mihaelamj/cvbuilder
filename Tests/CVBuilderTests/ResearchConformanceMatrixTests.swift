import Foundation
import Testing

@Suite("Research conformance matrix")
struct ResearchConformanceMatrixTests {
    @Test("research conformance matrix covers every surviving rule and enforcing test")
    func researchConformanceMatrixCoversEveryRuleAndTest() throws {
        let entries = researchConformanceEntries
        let repositoryRoot = repositoryRootURL()
        let knownTestNames = try discoveredTestNames(in: repositoryRoot.appendingPathComponent("Tests"))
        let document = try String(
            contentsOf: repositoryRoot.appendingPathComponent(
                "Sources/CVBuilderDocumentation/CVBuilderDocumentation.docc/ConformanceMatrix.md",
            ),
            encoding: .utf8,
        )

        let expectedRuleIDs = (1 ... 19).map { String(format: "R%02d", $0) }
        let actualRuleIDs = entries.map(\.ruleID)
        #expect(actualRuleIDs.sorted() == expectedRuleIDs)
        #expect(Set(actualRuleIDs).count == expectedRuleIDs.count)

        let entriesMissingCode = entries.filter(\.codeLocations.isEmpty).map(\.ruleID)
        let entriesMissingTests = entries.filter(\.testNames.isEmpty).map(\.ruleID)
        #expect(entriesMissingCode.isEmpty)
        #expect(entriesMissingTests.isEmpty)

        let missingCodeLocations = entries.flatMap(\.codeLocations).filter { codeLocation in
            !FileManager.default.fileExists(atPath: repositoryRoot.appendingPathComponent(codeLocation).path)
        }
        #expect(missingCodeLocations.isEmpty)

        let missingTestNames = Set(entries.flatMap(\.testNames)).subtracting(knownTestNames)
        #expect(missingTestNames.isEmpty)

        for entry in entries {
            #expect(document.contains("| \(entry.ruleID) |"))
            for codeLocation in entry.codeLocations {
                #expect(document.contains("`\(codeLocation)`"))
            }
            for testName in entry.testNames {
                #expect(document.contains(testName))
            }
        }
    }

    private func repositoryRootURL() -> URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    private func discoveredTestNames(in testsRoot: URL) throws -> Set<String> {
        let files = try swiftFiles(in: testsRoot)
        var names: Set<String> = []

        for file in files {
            let content = try String(contentsOf: file, encoding: .utf8)
            try names.formUnion(captures(pattern: #"@Test\("([^"]+)""#, in: content))
            try names.formUnion(captures(pattern: #"@Test\s+func\s+([A-Za-z_][A-Za-z0-9_]*)"#, in: content))
        }

        return names
    }

    private func swiftFiles(in root: URL) throws -> [URL] {
        guard let enumerator = FileManager.default.enumerator(
            at: root,
            includingPropertiesForKeys: [.isRegularFileKey],
        ) else {
            return []
        }

        var files: [URL] = []
        for item in enumerator {
            guard let file = item as? URL, file.pathExtension == "swift" else {
                continue
            }

            let values = try file.resourceValues(forKeys: [.isRegularFileKey])
            if values.isRegularFile == true {
                files.append(file)
            }
        }

        return files
    }

    private func captures(pattern: String, in content: String) throws -> [String] {
        let expression = try NSRegularExpression(pattern: pattern)
        let range = NSRange(content.startIndex ..< content.endIndex, in: content)

        return expression.matches(in: content, range: range).compactMap { match in
            guard let captureRange = Range(match.range(at: 1), in: content) else {
                return nil
            }

            return String(content[captureRange])
        }
    }
}

private struct ResearchConformanceEntry {
    let ruleID: String
    let codeLocations: [String]
    let testNames: [String]
}

private let researchConformanceEntries: [ResearchConformanceEntry] = [
    ResearchConformanceEntry(
        ruleID: "R01",
        codeLocations: [
            "Sources/CVBuilder/Document/CVDocument.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.swift",
        ],
        testNames: [
            "document preserves front matter, links, evidence, and technical focus",
            "runner renders Markdown from CVDocument JSON",
            "runner re-emits normalized JSON",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R02",
        codeLocations: [
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Policy.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift",
        ],
        testNames: [
            "experienced mode renders the proof-backed document shape",
            "rendering modes match checked-in Markdown fixtures",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R03",
        codeLocations: [
            "Sources/CVBuilder/Document/RenderingMode.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Policy.swift",
        ],
        testNames: [
            "experienced and early-career modes use different ordering",
            "democv fixture proves senior technical rendering behavior",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R04",
        codeLocations: [
            "Sources/CVBuilder/Document/RenderingMode.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Policy.swift",
        ],
        testNames: [
            "early career fixture promotes education before experience",
            "experienced and early-career modes use different ordering",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R05",
        codeLocations: [
            "Sources/CVBuilder/Document/RenderingOptions.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift",
        ],
        testNames: [
            "experienced mode renders the proof-backed document shape",
            "democv fixture proves senior technical rendering behavior",
            "positive rendering limits constrain work entries and project descriptions",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R06",
        codeLocations: [
            "Sources/CVBuilder/WorkExperience.swift",
            "Sources/CVBuilder/Project.swift",
            "Sources/CVBuilder/ProjectExperience.swift",
            "Sources/CVBuilder/Document/PublicEvidence.swift",
            "Sources/CVBuilder/Document/TechnicalFocus.swift",
        ],
        testNames: [
            "document preserves front matter, links, evidence, and technical focus",
            "public evidence carries context beyond a link",
            "experienced mode renders the proof-backed document shape",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R07",
        codeLocations: [
            "Sources/CVBuilder/Document/PublicEvidence.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift",
        ],
        testNames: [
            "public evidence carries context beyond a link",
            "experienced mode renders the proof-backed document shape",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R08",
        codeLocations: [
            "Sources/CVBuilder/Document/PublicEvidence.swift",
            "Sources/CVBuilder/Document/RenderingOptions.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.swift",
        ],
        testNames: [
            "renderer omits visual scoring demographic and table artifacts",
            "rendering options express ordering without scores",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R09",
        codeLocations: [
            "Sources/CVBuilder/Document/RenderingOptions.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.swift",
        ],
        testNames: [
            "renderer omits visual scoring demographic and table artifacts",
            "rendering options express ordering without scores",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R10",
        codeLocations: [
            "Sources/CVBuilder/Document/CVDocument.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.swift",
        ],
        testNames: [
            "renderer omits visual scoring demographic and table artifacts",
            "required document fixtures decode, render, and remain privacy safe",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R11",
        codeLocations: [
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift",
        ],
        testNames: [
            "renderer omits visual scoring demographic and table artifacts",
            "renderer keeps TileDown integration Markdown only",
            "hostile text is escaped as data, not Markdown structure",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R12",
        codeLocations: [
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Escaping.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Formatting.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift",
        ],
        testNames: [
            "rendering is byte-for-byte deterministic",
            "hostile text is escaped as data, not Markdown structure",
            "unsafe link destinations are encoded consistently",
            "front matter keys and scalar values are quoted and single-line",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R13",
        codeLocations: [
            "Sources/CVBuilder/Document/RenderingOptions.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Formatting.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift",
        ],
        testNames: [
            "checked-in JSON Schema covers document sections and authoring defaults",
            "rendering modes match checked-in Markdown fixtures",
            "non-compact skills are escaped as an engineering invariant",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R14",
        codeLocations: [
            "Sources/CVBuilder/WorkExperience.swift",
            "Sources/CVBuilder/ProjectExperience.swift",
            "Sources/CVBuilder/Document/TechnicalFocus.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Formatting.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift",
        ],
        testNames: [
            "document preserves front matter, links, evidence, and technical focus",
            "democv fixture proves senior technical rendering behavior",
            "early career fixture promotes education before experience",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R15",
        codeLocations: [
            "Sources/CVBuilder/Document/RenderingOptions.swift",
            "Sources/CVBuilder/Rendering/MarkdownCVRenderer.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.swift",
        ],
        testNames: [
            "renderer omits visual scoring demographic and table artifacts",
            "legacy CV-only Markdown renderer remains available",
            "renderer keeps TileDown integration Markdown only",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R16",
        codeLocations: [
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Escaping.swift",
        ],
        testNames: [
            "accessible heading structure has a single title and no skipped levels",
            "hostile text is escaped as data, not Markdown structure",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R17",
        codeLocations: [
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Formatting.swift",
            "Sources/CVBuilder/Period.swift",
        ],
        testNames: [
            "date rendering emits no auto-computed gaps or durations",
            "partial periods render the present bound, not a fabricated range",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R18",
        codeLocations: [
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift",
        ],
        testNames: [
            "accomplishment content renders verbatim without fabricated metrics",
        ],
    ),
    ResearchConformanceEntry(
        ruleID: "R19",
        codeLocations: [
            "Sources/CVBuilder/Document/RenderingLabels.swift",
            "Sources/CVBuilder/Document/RenderingLocale.swift",
            "Sources/CVBuilder/Rendering/Rendering.MarkdownDocumentRenderer.Sections.swift",
        ],
        testNames: [
            "localized output keeps a fixed name slot, stable structure, and no origin fields",
            "locale only changes labels, never the document structure",
        ],
    ),
]
