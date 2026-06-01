import Foundation

/// The public technical artifact category for `PublicEvidence`.
public enum PublicEvidenceKind: String, Codable, CaseIterable, Equatable, Sendable {
    /// Open-source repository, contribution, or maintained project.
    case openSource
    /// Conference, meetup, podcast, workshop, or internal technical talk.
    case talk
    /// Formal publication or article with technical substance.
    case publication
    /// Shipped application or app-store style product artifact.
    case app
    /// Reusable package or library.
    case package
    /// Technical writing that is not a formal publication.
    case technicalWriting
    /// Project artifact that does not fit the narrower categories.
    case project
    /// Explicit fallback for evidence outside the supported categories.
    case other
}
