import Foundation

/// Technical areas and tags attached to concrete work.
///
/// Attach `TechnicalFocus` to a role, project, project experience, or public
/// evidence item when a renderer needs to show why that work is technically
/// relevant. Keep global skills separate from this local context.
public struct TechnicalFocus: Codable, Equatable, Hashable, Sendable {
    /// Broader technical areas rendered as `Technical focus`.
    public let areas: [String]
    /// Concrete tags rendered as `Technical tags`.
    public let tags: [String]

    private enum CodingKeys: String, CodingKey {
        case areas
        case tags
    }

    public init(areas: [String] = [], tags: [String] = []) {
        self.areas = areas
        self.tags = tags
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        areas = try container.decode([String].self, forKey: .areas, defaultIfMissing: [])
        tags = try container.decode([String].self, forKey: .tags, defaultIfMissing: [])
    }
}
