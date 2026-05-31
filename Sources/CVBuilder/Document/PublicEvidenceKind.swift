import Foundation

/// The public technical artifact category for `PublicEvidence`.
public enum PublicEvidenceKind: String, Codable, CaseIterable, Equatable, Sendable {
    case openSource
    case talk
    case publication
    case app
    case package
    case technicalWriting
    case project
    case other
}
