import CVBuilder

public extension CVBuilderTileDown {
    /// Renders CVBuilder data into Markdown suitable for a TileDown-driven publishing pipeline.
    ///
    /// `Renderer` is an adapter over CVBuilder's canonical Markdown renderers.
    /// It returns a plain `String` and performs no file writes, PDF rendering,
    /// HTML rendering, or static-site generation. `CVDocument.frontMatter` is
    /// passed through to `Rendering.MarkdownDocumentRenderer`, so front matter
    /// ordering, escaping, and omission semantics stay identical to the core
    /// renderer.
    struct Renderer: Sendable {
        private let documentRenderer: Rendering.MarkdownDocumentRenderer
        private let legacyRenderer: MarkdownCVRenderer

        /// Creates a renderer that delegates to CVBuilder's deterministic Markdown renderers.
        ///
        /// Inject custom renderers only when testing adapter behavior. The
        /// default initializer uses the same production renderers as the core
        /// package.
        public init(
            documentRenderer: Rendering.MarkdownDocumentRenderer = .init(),
            legacyRenderer: MarkdownCVRenderer = .init(),
        ) {
            self.documentRenderer = documentRenderer
            self.legacyRenderer = legacyRenderer
        }

        /// Renders a complete `CVDocument` to deterministic Markdown.
        ///
        /// Prefer this overload for TileDown workflows. It preserves document
        /// front matter, links, public evidence, and rendering options exactly
        /// as the canonical Markdown renderer does.
        public func render(_ document: CVDocument) -> String {
            documentRenderer.render(document)
        }

        /// Renders a legacy `CV` value to Markdown.
        ///
        /// This compatibility overload emits Markdown for callers that still
        /// hold plain `CV` values. It does not add `CVDocument` front matter,
        /// links, public evidence, or rendering-mode behavior.
        public func render(cv resume: CV) -> String {
            legacyRenderer.render(cv: resume)
        }
    }
}
