import CVBuilder

extension CVBuilderTileDown {
    /// Renders CVBuilder data into Markdown suitable for a TileDown-driven publishing pipeline.
    public struct Renderer: Sendable {
        private let documentRenderer: Rendering.MarkdownDocumentRenderer
        private let legacyRenderer: MarkdownCVRenderer

        /// Creates a renderer that delegates to CVBuilder's deterministic Markdown renderers.
        public init(
            documentRenderer: Rendering.MarkdownDocumentRenderer = .init(),
            legacyRenderer: MarkdownCVRenderer = .init()
        ) {
            self.documentRenderer = documentRenderer
            self.legacyRenderer = legacyRenderer
        }

        /// Renders a complete `CVDocument` to deterministic Markdown.
        public func render(_ document: CVDocument) -> String {
            documentRenderer.render(document)
        }

        /// Renders a legacy `CV` value to Markdown.
        public func render(cv resume: CV) -> String {
            legacyRenderer.render(cv: resume)
        }
    }
}
