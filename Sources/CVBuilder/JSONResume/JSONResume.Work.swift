import Foundation

public extension JSONResume {
    /// JSON Resume `work` entry: one employer and role.
    struct Work: Codable, Equatable, Sendable {
        /// Employer or organization name.
        public let name: String
        /// Role or position title.
        public let position: String
        /// Employer website URL.
        public let url: String
        /// Start date in `YYYY-MM-DD`, `YYYY-MM`, or `YYYY` form.
        public let startDate: String
        /// End date in the same forms. Empty means the role is ongoing.
        public let endDate: String
        /// Short role summary.
        public let summary: String
        /// Bullet-point achievements.
        public let highlights: [String]

        private enum CodingKeys: String, CodingKey {
            case name
            case position
            case url
            case startDate
            case endDate
            case summary
            case highlights
        }

        public init(
            name: String = "",
            position: String = "",
            url: String = "",
            startDate: String = "",
            endDate: String = "",
            summary: String = "",
            highlights: [String] = [],
        ) {
            self.name = name
            self.position = position
            self.url = url
            self.startDate = startDate
            self.endDate = endDate
            self.summary = summary
            self.highlights = highlights
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            name = try container.decode(String.self, forKey: .name, defaultIfMissing: "")
            position = try container.decode(String.self, forKey: .position, defaultIfMissing: "")
            url = try container.decode(String.self, forKey: .url, defaultIfMissing: "")
            startDate = try container.decode(String.self, forKey: .startDate, defaultIfMissing: "")
            endDate = try container.decode(String.self, forKey: .endDate, defaultIfMissing: "")
            summary = try container.decode(String.self, forKey: .summary, defaultIfMissing: "")
            highlights = try container.decode([String].self, forKey: .highlights, defaultIfMissing: [])
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfNotEmpty(name, forKey: .name)
            try container.encodeIfNotEmpty(position, forKey: .position)
            try container.encodeIfNotEmpty(url, forKey: .url)
            try container.encodeIfNotEmpty(startDate, forKey: .startDate)
            try container.encodeIfNotEmpty(endDate, forKey: .endDate)
            try container.encodeIfNotEmpty(summary, forKey: .summary)
            try container.encodeIfNotEmpty(highlights, forKey: .highlights)
        }
    }
}
