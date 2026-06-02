import Foundation

/// Deterministic conversion between JSON Resume date strings and `Period.SimpleDate`.
///
/// JSON Resume dates are ISO-8601 calendar strings in `YYYY-MM-DD`, `YYYY-MM`,
/// or `YYYY` form. `CVDocument` stores month and year only, so day precision is
/// dropped on import and a missing month defaults to January. The canonical
/// output form is `YYYY-MM`, which round-trips byte-for-byte; the other input
/// forms are lossy (see the JSONResumeInterop catalog article).
enum JSONResumeDate {
    /// Parses a JSON Resume date string into month and year.
    ///
    /// Returns `nil` when the string is empty or has no parseable leading year.
    /// A missing month component defaults to `1`. Day components are ignored.
    static func simpleDate(from string: String) -> Period.SimpleDate? {
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            return nil
        }

        let components = trimmed.split(separator: "-", maxSplits: 2, omittingEmptySubsequences: false)
        guard let year = Int(components[0]), year > 0 else {
            return nil
        }

        let month: Int = if components.count >= 2, let parsedMonth = Int(components[1]), (1 ... 12).contains(parsedMonth) {
            parsedMonth
        } else {
            1
        }

        return Period.SimpleDate(month: month, year: year)
    }

    /// Renders month and year as the canonical `YYYY-MM` form.
    ///
    /// An out-of-range month (only reachable for an in-memory value that
    /// bypassed `SimpleDate` decode validation) falls back to the valid `YYYY`
    /// form, which re-imports cleanly, instead of emitting a non-ISO `0050-13`.
    static func string(from date: Period.SimpleDate) -> String {
        guard (1 ... 12).contains(date.month) else {
            return String(format: "%04d", date.year)
        }

        return String(format: "%04d-%02d", date.year, date.month)
    }

    /// Renders an optional date, or the empty string when it is absent.
    ///
    /// An absent date is omitted from JSON Resume output (the model uses
    /// `encodeIfNotEmpty`), so an entry whose `startDate`/`endDate` was missing
    /// on import re-exports with that field still absent.
    static func string(from date: Period.SimpleDate?) -> String {
        date.map(string(from:)) ?? ""
    }
}
