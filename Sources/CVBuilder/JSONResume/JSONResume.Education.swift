import Foundation

public extension JSONResume {
    /// JSON Resume `education` entry.
    struct Education: Codable, Equatable, Sendable {
        /// Institution name.
        public let institution: String
        /// Field of study, mapped to `Education.field`.
        public let area: String
        /// Degree or study type, mapped to `Education.degree`.
        public let studyType: String
        /// Start date in `YYYY-MM-DD`, `YYYY-MM`, or `YYYY` form.
        public let startDate: String
        /// End date in the same forms.
        public let endDate: String

        private enum CodingKeys: String, CodingKey {
            case institution
            case area
            case studyType
            case startDate
            case endDate
        }

        public init(
            institution: String = "",
            area: String = "",
            studyType: String = "",
            startDate: String = "",
            endDate: String = "",
        ) {
            self.institution = institution
            self.area = area
            self.studyType = studyType
            self.startDate = startDate
            self.endDate = endDate
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            institution = try container.decode(String.self, forKey: .institution, defaultIfMissing: "")
            area = try container.decode(String.self, forKey: .area, defaultIfMissing: "")
            studyType = try container.decode(String.self, forKey: .studyType, defaultIfMissing: "")
            startDate = try container.decode(String.self, forKey: .startDate, defaultIfMissing: "")
            endDate = try container.decode(String.self, forKey: .endDate, defaultIfMissing: "")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfNotEmpty(institution, forKey: .institution)
            try container.encodeIfNotEmpty(area, forKey: .area)
            try container.encodeIfNotEmpty(studyType, forKey: .studyType)
            try container.encodeIfNotEmpty(startDate, forKey: .startDate)
            try container.encodeIfNotEmpty(endDate, forKey: .endDate)
        }
    }
}
