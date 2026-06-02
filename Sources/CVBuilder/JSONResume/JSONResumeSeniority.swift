import Foundation

/// Deterministic seniority inference for JSON Resume `work.position` strings.
///
/// JSON Resume has no seniority concept, so import infers a `Role.Seniority`
/// from a recognized leading word in the position title and strips that word
/// from the remaining `Role.title`. Export reverses this by emitting
/// `Role.name` (the seniority word rejoined to the title), so a position such
/// as `Senior iOS Engineer` round-trips byte-for-byte. A position with no
/// recognized leading seniority word defaults to `.mid`; export then prefixes
/// `Mid`, which is the one documented lossy case for positions.
enum JSONResumeSeniority {
    /// Splits a position string into an inferred seniority and the residual title.
    static func split(position: String) -> (seniority: Role.Seniority, title: String) {
        let trimmed = position.trimmingCharacters(in: .whitespaces)
        let parts = trimmed.split(separator: " ", maxSplits: 1)

        guard
            let firstWord = parts.first,
            let seniority = Role.Seniority(rawValue: String(firstWord)),
            parts.count == 2
        else {
            return (.mid, trimmed)
        }

        return (seniority, String(parts[1]).trimmingCharacters(in: .whitespaces))
    }
}
