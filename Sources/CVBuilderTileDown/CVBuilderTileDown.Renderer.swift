import CVBuilder

extension CVBuilderTileDown {
    /// Renders CVBuilder data into Markdown suitable for a TileDown-driven publishing pipeline.
    public struct Renderer {
        /// Creates a renderer that delegates to CVBuilder's deterministic Markdown renderers.
        public init() {}

        /// Renders a complete `CVDocument` to deterministic Markdown.
        public func render(_ document: CVDocument) -> String {
            Rendering.MarkdownDocumentRenderer().render(document)
        }

        /// Renders a legacy `CV` value to Markdown.
        public func render(cv resume: CV) -> String {
            MarkdownCVRenderer().render(cv: resume)
        }
    }
}
