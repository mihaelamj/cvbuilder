import Foundation

/// Deterministic seniority inference for JSON Resume `work.position` strings.
///
/// JSON Resume has no seniority concept, so import infers a `Role.Seniority`
/// from a recognized leading word (matched case-insensitively) in a multi-word
/// position and strips that word from the remaining `Role.title`. Export
/// reverses this with `position(seniority:title:)`, which rejoins a recognized
/// seniority but emits the title alone for the `.mid` default, so a position
/// with no leading seniority word (or a single-word or empty position) round
/// trips without a fabricated `Mid` prefix or trailing space.
///
/// Two cases are deliberately lossy: a leading word matched case-insensitively
/// re-emits in canonical casing (`senior` becomes `Senior`), and internal runs
/// of whitespace in the title collapse to a single space. An explicit leading
/// `Mid ` is dropped on export because it is indistinguishable from the
/// no-seniority default. See the JSONResumeInterop catalog article.
enum JSONResumeSeniority {
    /// Splits a position string into an inferred seniority and the residual title.
    static func split(position: String) -> (seniority: Role.Seniority, title: String) {
        let trimmed = position.trimmingCharacters(in: .whitespaces)
        let parts = trimmed.split(separator: " ", maxSplits: 1)

        guard
            parts.count == 2,
            let firstWord = parts.first,
            let seniority = seniority(forLeadingWord: String(firstWord))
        else {
            return (.mid, trimmed)
        }

        return (seniority, String(parts[1]).trimmingCharacters(in: .whitespaces))
    }

    /// Rebuilds a JSON Resume position from an inferred seniority and title.
    ///
    /// The `.mid` default carries no seniority word (it is the "no recognized
    /// leading word" case), so it emits the title alone. Any other seniority is
    /// prefixed in canonical casing.
    static func position(seniority: Role.Seniority, title: String) -> String {
        guard seniority != .mid else {
            return title
        }

        guard !title.isEmpty else {
            return seniority.rawValue
        }

        return "\(seniority.rawValue) \(title)"
    }

    private static func seniority(forLeadingWord word: String) -> Role.Seniority? {
        let lowercasedWord = word.lowercased()
        return Role.Seniority.allCases.first { $0.rawValue.lowercased() == lowercasedWord }
    }
}
