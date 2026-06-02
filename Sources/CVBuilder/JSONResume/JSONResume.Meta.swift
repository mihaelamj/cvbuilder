import Foundation

public extension JSONResume {
    /// JSON Resume `meta`: document-level metadata.
    ///
    /// Part of the faithful JSON Resume model, but `CVDocument` has no place to
    /// store it: import drops `meta` and export never emits it. It does not
    /// survive a `CVDocument` conversion in either direction.
    struct Meta: Codable, Equatable, Sendable {
        /// Canonical URL of the published resume.
        public let canonical: String
        /// JSON Resume schema version.
        public let version: String
        /// Last-modified timestamp.
        public let lastModified: String

        private enum CodingKeys: String, CodingKey {
            case canonical
            case version
            case lastModified
        }

        public init(canonical: String = "", version: String = "", lastModified: String = "") {
            self.canonical = canonical
            self.version = version
            self.lastModified = lastModified
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            canonical = try container.decode(String.self, forKey: .canonical, defaultIfMissing: "")
            version = try container.decode(String.self, forKey: .version, defaultIfMissing: "")
            lastModified = try container.decode(String.self, forKey: .lastModified, defaultIfMissing: "")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfNotEmpty(canonical, forKey: .canonical)
            try container.encodeIfNotEmpty(version, forKey: .version)
            try container.encodeIfNotEmpty(lastModified, forKey: .lastModified)
        }
    }
}
