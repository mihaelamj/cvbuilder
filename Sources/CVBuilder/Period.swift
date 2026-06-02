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

    public let start: SimpleDate
    public let end: SimpleDate

    private enum CodingKeys: String, CodingKey {
        case start
        case end
    }

    var formattedDateRange: String {
        "\(start.month)/\(start.year) - \(end.month)/\(end.year)"
    }

    public var id: String {
        "\(start.id)_to_\(end.id)"
    }

    public init(start: Period.SimpleDate, end: Period.SimpleDate) {
        self.start = start
        self.end = end
    }

    /// Rejects a reversed period (`start` later than `end`) at the model
    /// boundary. Equal start and end are permitted and collapse to a single
    /// token when rendered.
    ///
    /// This ordering invariant is enforced here rather than in the JSON Schema
    /// because JSON Schema cannot express a comparison between two sibling
    /// properties, so the decoder is the single authority for it. The CLI runs
    /// schema validation first, then decoding, so a reversed period surfaces as
    /// a decode error with a clear message.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let start = try container.decode(SimpleDate.self, forKey: .start)
        let end = try container.decode(SimpleDate.self, forKey: .end)

        guard start <= end else {
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
