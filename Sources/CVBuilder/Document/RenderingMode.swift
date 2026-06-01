import Foundation

/// The high-level ordering strategy for a technical CV document.
public enum RenderingMode: String, Codable, CaseIterable, Equatable, Sendable {
    /// Orders experience before education for candidates with substantial work history.
    case experiencedTechnical
    /// Orders education before experience for earlier-career technical candidates.
    case earlyCareerTechnical
}
