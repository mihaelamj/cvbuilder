/// Static-site-generator front matter profile for generated Markdown.
///
/// Profiles affect only the metadata block emitted before the Markdown body.
/// They do not change CV facts, section ordering, links, or body rendering.
public enum FrontMatterProfile: String, CaseIterable, Codable, Equatable, Sendable {
    /// Existing deterministic YAML-style front matter.
    case generic
    /// Toucan-compatible YAML front matter with Toucan-oriented key ordering.
    case toucan
    /// Hugo-compatible TOML front matter.
    case hugo
    /// Jekyll-compatible YAML front matter with Jekyll-oriented key ordering.
    case jekyll
}
