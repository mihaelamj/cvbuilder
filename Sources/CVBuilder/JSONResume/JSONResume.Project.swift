import Foundation

public extension JSONResume {
    /// JSON Resume `projects` entry. Maps to one `PublicEvidence` item.
    struct Project: Codable, Equatable, Sendable {
        /// Project name, mapped to `PublicEvidence.title`.
        public let name: String
        /// Short description, mapped to `PublicEvidence.summary`.
        public let description: String
        /// Bullet-point highlights.
        public let highlights: [String]
        /// Technology keywords, mapped to `PublicEvidence.technologies`.
        public let keywords: [String]
        /// Start date in `YYYY-MM-DD`, `YYYY-MM`, or `YYYY` form.
        public let startDate: String
        /// End date in the same forms.
        public let endDate: String
        /// Project URL, mapped to `PublicEvidence.url`.
        public let url: String
        /// Roles held on the project. Only the first maps to `PublicEvidence.role`.
        public let roles: [String]
        /// Owning entity or organization.
        public let entity: String
        /// Free-form project type, mapped to and from `PublicEvidenceKind`.
        public let type: String

        private enum CodingKeys: String, CodingKey {
            case name
            case description
            case highlights
            case keywords
            case startDate
            case endDate
            case url
            case roles
            case entity
            case type
        }

        public init(
            name: String = "",
            description: String = "",
            highlights: [String] = [],
            keywords: [String] = [],
            startDate: String = "",
            endDate: String = "",
            url: String = "",
            roles: [String] = [],
            entity: String = "",
            type: String = "",
        ) {
            self.name = name
            self.description = description
            self.highlights = highlights
            self.keywords = keywords
            self.startDate = startDate
            self.endDate = endDate
            self.url = url
            self.roles = roles
            self.entity = entity
            self.type = type
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            name = try container.decode(String.self, forKey: .name, defaultIfMissing: "")
            description = try container.decode(String.self, forKey: .description, defaultIfMissing: "")
            highlights = try container.decode([String].self, forKey: .highlights, defaultIfMissing: [])
            keywords = try container.decode([String].self, forKey: .keywords, defaultIfMissing: [])
            startDate = try container.decode(String.self, forKey: .startDate, defaultIfMissing: "")
            endDate = try container.decode(String.self, forKey: .endDate, defaultIfMissing: "")
            url = try container.decode(String.self, forKey: .url, defaultIfMissing: "")
            roles = try container.decode([String].self, forKey: .roles, defaultIfMissing: [])
            entity = try container.decode(String.self, forKey: .entity, defaultIfMissing: "")
            type = try container.decode(String.self, forKey: .type, defaultIfMissing: "")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfNotEmpty(name, forKey: .name)
            try container.encodeIfNotEmpty(description, forKey: .description)
            try container.encodeIfNotEmpty(highlights, forKey: .highlights)
            try container.encodeIfNotEmpty(keywords, forKey: .keywords)
            try container.encodeIfNotEmpty(startDate, forKey: .startDate)
            try container.encodeIfNotEmpty(endDate, forKey: .endDate)
            try container.encodeIfNotEmpty(url, forKey: .url)
            try container.encodeIfNotEmpty(roles, forKey: .roles)
            try container.encodeIfNotEmpty(entity, forKey: .entity)
            try container.encodeIfNotEmpty(type, forKey: .type)
        }
    }
}
