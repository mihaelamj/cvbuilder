import Foundation

public extension Rendering {
    /// Renders a complete `CVDocument` into factual, source-order Markdown.
    ///
    /// `MarkdownDocumentRenderer` is intentionally conservative: it emits flat
    /// front matter, predictable headings, paragraphs, and labelled lines. It
    /// does not render tables, columns, images, scores, demographic metadata, or
    /// inferred fit labels.
    struct MarkdownDocumentRenderer: Sendable {
        /// Localized strings for headings, labels, and month names.
        ///
        /// Resolved from the document's `RenderingOptions.locale` at the start of
        /// `render(_:)`; defaults to English so a directly constructed renderer
        /// keeps the original output.
        var labels: RenderingLabels = .english

        /// Whether periods render as a duration (`3 yrs`) instead of a date
        /// range. Resolved from `RenderingOptions.useDurationPeriods` at the
        /// start of `render(_:)`; defaults to the date-range form.
        var usesDurationPeriods = false

        /// Creates a renderer with the default evidence-backed Markdown policy.
        public init() {}

        /// Returns deterministic Markdown for the supplied document.
        public func render(_ document: CVDocument) -> String {
            var renderer = self
            renderer.labels = document.rendering.locale.labels
            renderer.usesDurationPeriods = document.rendering.useDurationPeriods
            return renderer.renderDocument(document)
        }

        private func renderDocument(_ document: CVDocument) -> String {
            var writer = Writer()

            renderFrontMatter(
                document.frontMatter,
                profile: document.rendering.frontMatterProfile,
                writer: &writer,
            )
            renderHeader(document.cv, writer: &writer)

            for section in sections(for: document.rendering.mode) {
                switch section {
                case .contact:
                    renderContact(document.cv.contactInfo, writer: &writer)
                case .experience:
                    renderExperience(
                        document.cv.experience,
                        links: document.links,
                        options: document.rendering,
                        writer: &writer,
                    )
                case .projects:
                    renderProjects(document.cv.experience, options: document.rendering, writer: &writer)
                case .education:
                    renderEducation(document.cv.education, options: document.rendering, writer: &writer)
                case .publicEvidence:
                    renderPublicEvidence(document.publicEvidence, options: document.rendering, writer: &writer)
                case .skills:
                    renderSkills(document.cv.skills, options: document.rendering, writer: &writer)
                case .links:
                    renderLinks(document.links, options: document.rendering, writer: &writer)
                }
            }

            return writer.output
        }

        /// Writes deterministic Markdown for the supplied document.
        public func save(_ document: CVDocument, to url: URL) throws {
            try render(document).write(to: url, atomically: true, encoding: .utf8)
        }
    }
}
