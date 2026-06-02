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

        /// Creates a renderer that delegates to CVBuilder's deterministic Markdown renderers.
        public init(documentRenderer: Rendering.MarkdownDocumentRenderer = .init()) {
            self.documentRenderer = documentRenderer
        }

        /// Creates a renderer while preserving the former legacy-renderer injection shape.
        @available(*, deprecated, message: "Use init(documentRenderer:) instead.")
        public init(
            documentRenderer: Rendering.MarkdownDocumentRenderer = .init(),
            legacyRenderer _: MarkdownCVRenderer,
        ) {
            self.documentRenderer = documentRenderer
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
        /// This compatibility overload wraps the value in a default `CVDocument`
        /// so escaping, determinism, and low-noise Markdown stay identical to
        /// the canonical renderer. It does not add front matter, document
        /// links, public evidence, or custom rendering options.
        public func render(cv resume: CV) -> String {
            documentRenderer.render(CVDocument(cv: resume))
        }
    }
}
