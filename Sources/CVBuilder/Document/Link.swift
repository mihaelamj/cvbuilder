import Foundation

/// A labelled destination used by document-level publishing sections.
///
/// The destination is a `String` instead of `URL` so documents can carry full
/// URLs, site-root paths, relative paths, anchors, and later renderer-specific
/// validation without losing author intent during decoding.
public struct Link: Codable, Equatable, Sendable {
    public let label: String
    public let url: String

    public init(label: String, url: String) {
        self.label = label
        self.url = url
    }
}
