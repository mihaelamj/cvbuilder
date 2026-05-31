import Foundation

/// A labelled hyperlink used in a CV document (e.g. a conference website).
public struct Link: Codable, Hashable {
    public let label: String
    public let url: URL

    public init(label: String, url: URL) {
        self.label = label
        self.url = url
    }
}
