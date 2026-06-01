#if os(Linux)
    @testable import CVBuilder
    import CVBuilderTileDown
    import Foundation
    import Testing

    @Suite("CVBuilderTileDown contract")
    struct CVBuilderTileDownContractTests {
        @Test("document renderer matches canonical Markdown for democv fixture")
        func documentRendererMatchesCanonicalMarkdownForDemoFixture() throws {
            let document = try Self.demoDocument()
            let adapterOutput = CVBuilderTileDown.Renderer().render(document)
            let canonicalOutput = Rendering.MarkdownDocumentRenderer().render(document)
            let exampleOutput = try Self.readUTF8Fixture("Examples/tiledown/democv.md")

            #expect(adapterOutput == canonicalOutput)
            #expect(adapterOutput == exampleOutput)
            #expect(adapterOutput.hasPrefix("""
            ---
            slug: "demo-cv"
            title: "Demo Curriculum Vitae"
            ---

            # Alex Rivera
            """))
        }

        @Test("renderer keeps TileDown integration Markdown only")
        func rendererKeepsTileDownIntegrationMarkdownOnly() throws {
            let output = try CVBuilderTileDown.Renderer().render(Self.demoDocument())

            #expect(output.contains("## Experience"))
            #expect(output.contains("[Northbridge Systems](https://example.com/northbridge)"))
            #expect(!output.contains("<html"))
            #expect(!output.contains("%PDF"))
            #expect(!output.contains("CVBuilderIgnite"))
        }

        private static func demoDocument() throws -> CVDocument {
            let data = try Data(contentsOf: fixtureURL("Examples/democv/cv.json"))
            return try JSONDecoder().decode(CVDocument.self, from: data)
        }

        private static func readUTF8Fixture(_ relativePath: String) throws -> String {
            var text = try String(
                contentsOf: fixtureURL(relativePath),
                encoding: .utf8,
            )
            if text.hasSuffix("\n") {
                text.removeLast()
            }
            return text
        }

        private static func fixtureURL(_ relativePath: String) -> URL {
            let testsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
            return testsDirectory
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent(relativePath)
        }
    }
#endif
