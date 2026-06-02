@testable import CVBuilder
import Foundation
import Testing

/// Regression coverage for date-model validation (#109): month range at the
/// model boundary, reversed/equal periods, and the malformed-month fallbacks in
/// every formatter.
@Suite("Period and SimpleDate validation")
struct PeriodValidationTests {
    // MARK: - #109 month-range validation at decode

    @Test("decoding a month outside 1...12 fails", arguments: [0, 13, -1, 100, 99])
    func decodeRejectsOutOfRangeMonth(_ month: Int) throws {
        try expectDecodeFails(Period.SimpleDate.self, from: #"{"month": \#(month), "year": 2024}"#)
    }

    @Test("decoding an in-range month succeeds", arguments: [1, 6, 12])
    func decodeAcceptsInRangeMonth(_ month: Int) throws {
        let date = try decode(Period.SimpleDate.self, from: #"{"month": \#(month), "year": 2024}"#)
        #expect(date.month == month)
    }

    @Test("a CVDocument with an out-of-range month is rejected by a bare JSONDecoder")
    func decodeCVDocumentRejectsOutOfRangeMonth() throws {
        try expectDecodeFails(CVDocument.self, from: outOfRangeMonthDocumentJSON)
    }

    // MARK: - #109 reversed / equal periods

    @Test("a reversed period (start later than end) is rejected at decode")
    func decodeRejectsReversedPeriod() throws {
        try expectDecodeFails(
            Period.self,
            from: #"{"start": {"month": 6, "year": 2026}, "end": {"month": 1, "year": 2024}}"#,
        )
    }

    @Test("an equal-start-and-end period decodes successfully")
    func decodeAcceptsEqualPeriod() throws {
        let period = try decode(
            Period.self,
            from: #"{"start": {"month": 6, "year": 2024}, "end": {"month": 6, "year": 2024}}"#,
        )
        #expect(period.start == period.end)
    }

    @Test("an equal-start-and-end period renders as a single token")
    func equalPeriodCollapsesWhenRendered() {
        let renderer = Rendering.MarkdownDocumentRenderer()
        let period = Period(start: .init(month: 6, year: 2024), end: .init(month: 6, year: 2024))

        #expect(renderer.format(period, isCurrent: false) == "Jun 2024")
    }

    @Test("a distinct period still renders a start-end range")
    func distinctPeriodRendersRange() {
        let renderer = Rendering.MarkdownDocumentRenderer()
        let period = Period(start: .init(month: 1, year: 2024), end: .init(month: 6, year: 2026))

        #expect(renderer.format(period, isCurrent: false) == "Jan 2024 - Jun 2026")
    }

    // MARK: - #110 optional period bounds

    @Test("a period may omit start, end, or both")
    func periodBoundsAreOptional() throws {
        let startOnly = try decode(Period.self, from: #"{"start": {"month": 3, "year": 2020}}"#)
        #expect(startOnly.start == Period.SimpleDate(month: 3, year: 2020))
        #expect(startOnly.end == nil)

        let endOnly = try decode(Period.self, from: #"{"end": {"month": 6, "year": 2021}}"#)
        #expect(endOnly.start == nil)
        #expect(endOnly.end == Period.SimpleDate(month: 6, year: 2021))

        let neither = try decode(Period.self, from: "{}")
        #expect(neither.start == nil)
        #expect(neither.end == nil)
    }

    @Test("an explicit null period bound is rejected")
    func explicitNullPeriodBoundIsRejected() throws {
        try expectDecodeFails(Period.self, from: #"{"start": null, "end": {"month": 6, "year": 2021}}"#)
    }

    @Test("partial periods render the present bound, not a fabricated range")
    func partialPeriodsRenderPresentBound() {
        let renderer = Rendering.MarkdownDocumentRenderer()

        let startOnly = Period(start: .init(month: 1, year: 2024), end: nil)
        let endOnly = Period(start: nil, end: .init(month: 6, year: 2026))
        let empty = Period(start: nil, end: nil)

        #expect(renderer.format(startOnly, isCurrent: false) == "Jan 2024")
        #expect(renderer.format(endOnly, isCurrent: false) == "Jun 2026")
        #expect(renderer.format(empty, isCurrent: false) == "")
        #expect(renderer.format(empty, isCurrent: true) == renderer.labels.present)
        #expect(renderer.format(startOnly, isCurrent: true) == "Jan 2024 - \(renderer.labels.present)")
    }

    // MARK: - #109 formatter fallbacks for out-of-range months

    @Test("the renderer falls back to a valid year-only token for an out-of-range month")
    func rendererFallsBackToYearForOutOfRangeMonth() {
        let renderer = Rendering.MarkdownDocumentRenderer()

        #expect(renderer.format(Period.SimpleDate(month: 13, year: 2024)) == "2024")
        #expect(renderer.format(Period.SimpleDate(month: 0, year: 2024)) == "2024")
        #expect(renderer.format(Period.SimpleDate(month: -1, year: 2024)) == "2024")
    }

    @Test("JSON Resume export emits valid YYYY-MM and never a malformed month")
    func jsonResumeExportNeverEmitsMalformedMonth() {
        #expect(JSONResumeDate.string(from: .init(month: 5, year: 2020)) == "2020-05")
        #expect(JSONResumeDate.string(from: .init(month: 13, year: 50)) == "0050")
        #expect(JSONResumeDate.string(from: .init(month: -1, year: 50)) == "0050")
    }

    @Test("SimpleDate.id is a well-formed YYYY-MM token for valid months")
    func simpleDateIDIsWellFormed() {
        #expect(Period.SimpleDate(month: 6, year: 2024).id == "2024-06")
        #expect(Period.SimpleDate(month: 12, year: 2024).id == "2024-12")
    }

    // MARK: - Helpers

    private func decode<Value: Decodable>(_ type: Value.Type, from json: String) throws -> Value {
        let data = try #require(json.data(using: .utf8))
        return try JSONDecoder().decode(type, from: data)
    }

    private func expectDecodeFails(_ type: (some Decodable).Type, from json: String) throws {
        let data = try #require(json.data(using: .utf8))

        do {
            _ = try JSONDecoder().decode(type, from: data)
            Issue.record("Expected decoding of \(type) to fail")
        } catch is DecodingError {
            return
        } catch {
            Issue.record("Expected DecodingError, got \(error)")
        }
    }
}

private let outOfRangeMonthDocumentJSON = """
{
  "cv": {
    "name": "A",
    "title": "T",
    "summary": "S",
    "contactInfo": { "email": "a@b.c", "phone": "+100000000", "location": "Somewhere" },
    "experience": [
      {
        "company": { "name": "Acme" },
        "role": { "title": "Engineer", "seniority": "Senior" },
        "period": {
          "start": { "month": 99, "year": 2024 },
          "end": { "month": 6, "year": 2026 }
        }
      }
    ]
  }
}
"""
