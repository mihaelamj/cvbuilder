import Foundation

public struct Period: Codable, Identifiable, Equatable, Hashable, Sendable {
    public struct SimpleDate: Codable, Identifiable, Hashable, Equatable, Sendable {
        public let month: Int
        public let year: Int

        public var id: String {
            "\(year)-\(String(format: "%02d", month))"
        }

        private enum CodingKeys: String, CodingKey {
            case month
            case year
        }

        public init(month: Int, year: Int) {
            self.month = month
            self.year = year
        }

        /// Validates `month` against the published JSON Schema range (`1...12`)
        /// at the model boundary, so decoding through a bare `JSONDecoder`
        /// rejects the same malformed months the CLI's schema validator does
        /// instead of letting `2024-13` style tokens reach the formatters.
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let month = try container.decode(Int.self, forKey: .month)
            let year = try container.decode(Int.self, forKey: .year)

            guard (1 ... 12).contains(month) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: container.codingPath + [CodingKeys.month],
                    debugDescription: "month \(month) is out of range; expected 1...12",
                ))
            }

            self.month = month
            self.year = year
        }
    }

    /// Optional start date. Absent when the source did not supply one (notably a
    /// JSON Resume entry with no `startDate`), so absence survives a round trip
    /// instead of being fabricated as a sentinel date.
    public let start: SimpleDate?
    /// Optional end date. Absent for an open-ended or ongoing period.
    public let end: SimpleDate?

    private enum CodingKeys: String, CodingKey {
        case start
        case end
    }

    public var id: String {
        "\(start?.id ?? "")_to_\(end?.id ?? "")"
    }

    public init(start: Period.SimpleDate?, end: Period.SimpleDate?) {
        self.start = start
        self.end = end
    }

    /// Decodes the optional `start`/`end` dates. A missing key stays `nil` so
    /// the field round-trips as absent; an explicit `null` is rejected.
    ///
    /// Rejects a reversed period (`start` later than `end`) when both are
    /// present. This ordering invariant is enforced here rather than in the JSON
    /// Schema because JSON Schema cannot express a comparison between two sibling
    /// properties, so the decoder is the single authority for it. The CLI runs
    /// schema validation first, then decoding, so a reversed period surfaces as
    /// a decode error with a clear message.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let start = try container.decodeOmittable(SimpleDate.self, forKey: .start)
        let end = try container.decodeOmittable(SimpleDate.self, forKey: .end)

        if let start, let end, start > end {
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "period start (\(start.id)) is later than end (\(end.id))",
            ))
        }

        self.start = start
        self.end = end
    }
}

/// Add Comparable conformance to SimpleDate
extension Period.SimpleDate: Comparable {
    public static func < (lhs: Period.SimpleDate, rhs: Period.SimpleDate) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        }
        return lhs.month < rhs.month
    }
}

extension Period.SimpleDate {
    /// Orders two optional dates ascending, treating an absent date as later
    /// than any present date. Sorting ascending therefore puts absent dates
    /// last; swapping the arguments to sort descending puts them first (an
    /// ongoing or unknown bound is the most recent). Keeps date-driven ordering
    /// total and deterministic now that period bounds are optional.
    static func isAscending(_ lhs: Period.SimpleDate?, before rhs: Period.SimpleDate?) -> Bool {
        switch (lhs, rhs) {
        case let (lhs?, rhs?):
            lhs < rhs
        case (_?, nil):
            true
        case (nil, _?):
            false
        case (nil, nil):
            false
        }
    }
}
