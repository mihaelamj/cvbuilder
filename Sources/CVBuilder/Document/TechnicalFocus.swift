import Foundation

/// Technical areas and tags attached to concrete work.
///
/// Attach `TechnicalFocus` to a role, project, project experience, or public
/// evidence item when a renderer needs to show why that work is technically
/// relevant. Keep global skills separate from this local context.
public struct TechnicalFocus: Codable, Equatable, Hashable, Sendable {
    public let areas: [String]
    public let tags: [String]

    public init(areas: [String] = [], tags: [String] = []) {
        self.areas = areas
        self.tags = tags
    }
}
