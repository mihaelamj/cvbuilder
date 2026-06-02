import Foundation

public extension JSONResume {
    /// JSON Resume `skills` entry.
    ///
    /// A skill is either a single named competency or a grouping whose
    /// `keywords` list the individual competencies. Import expands `keywords`
    /// into separate `Tech` values; export emits one skill per `Tech`.
    struct Skill: Codable, Equatable, Sendable {
        /// Skill or skill-group name.
        public let name: String
        /// Optional proficiency label. Not represented in `CVDocument`.
        public let level: String
        /// Individual competencies when `name` is a grouping.
        public let keywords: [String]

        private enum CodingKeys: String, CodingKey {
            case name
            case level
            case keywords
        }

        public init(name: String = "", level: String = "", keywords: [String] = []) {
            self.name = name
            self.level = level
            self.keywords = keywords
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            name = try container.decode(String.self, forKey: .name, defaultIfMissing: "")
            level = try container.decode(String.self, forKey: .level, defaultIfMissing: "")
            keywords = try container.decode([String].self, forKey: .keywords, defaultIfMissing: [])
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfNotEmpty(name, forKey: .name)
            try container.encodeIfNotEmpty(level, forKey: .level)
            try container.encodeIfNotEmpty(keywords, forKey: .keywords)
        }
    }
}
