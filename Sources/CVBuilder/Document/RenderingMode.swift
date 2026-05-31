import Foundation

/// The high-level ordering strategy for a technical CV document.
public enum RenderingMode: String, Codable, CaseIterable, Equatable, Sendable {
    case experiencedTechnical
    case earlyCareerTechnical
}
