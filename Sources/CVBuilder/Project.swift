import Foundation

public struct Project: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let name: String
    public let company: Company
    public let descriptions: [String]
    public let techs: [Tech]
    public let role: Role
    public let period: Period
    public let urls: [URL]?
    public let isCurrent: Bool
    public let technicalFocus: TechnicalFocus?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case company
        case descriptions
        case techs
        case role
        case period
        case urls
        case isCurrent
        case technicalFocus
    }

    public init(
        id: UUID = UUID(),
        name: String,
        company: Company,
        descriptions: [String],
        techs: [Tech],
        role: Role,
        period: Period,
        urls: [URL]? = nil,
        isCurrent: Bool = false,
        technicalFocus: TechnicalFocus? = nil,
    ) {
        self.id = id
        self.name = name
        self.company = company
        self.descriptions = descriptions
        self.techs = techs
        self.role = role
        self.period = period
        self.urls = urls
        self.isCurrent = isCurrent
        self.technicalFocus = technicalFocus
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id, defaultIfMissing: UUID())
        name = try container.decode(String.self, forKey: .name)
        company = try container.decode(Company.self, forKey: .company)
        descriptions = try container.decode([String].self, forKey: .descriptions, defaultIfMissing: [])
        techs = try container.decode([Tech].self, forKey: .techs, defaultIfMissing: [])
        role = try container.decode(Role.self, forKey: .role)
        period = try container.decode(Period.self, forKey: .period)
        urls = try container.decodeIfPresent([URL].self, forKey: .urls)
        isCurrent = try container.decode(Bool.self, forKey: .isCurrent, defaultIfMissing: false)
        technicalFocus = try container.decodeIfPresent(TechnicalFocus.self, forKey: .technicalFocus)
    }

    public class Builder {
        private var id: UUID = .init()
        private var name: String = ""
        private var company: Company?
        private var descriptions: [String] = []
        private var techs: [Tech] = []
        private var role: Role = .none
        private var period: Period?
        private var urls: [URL]?
        private var isCurrent: Bool = false
        private var technicalFocus: TechnicalFocus?

        public init() {}

        @discardableResult
        public func withName(_ name: String) -> Builder {
            self.name = name
            return self
        }

        @discardableResult
        public func withCompany(_ company: Company) -> Builder {
            self.company = company
            return self
        }

        @discardableResult
        public func withDescriptions(_ descriptions: [String]) -> Builder {
            self.descriptions = descriptions
            return self
        }

        @discardableResult
        public func addDescription(_ description: String) -> Builder {
            descriptions.append(description)
            return self
        }

        @discardableResult
        public func withTechs(_ techs: [Tech]) -> Builder {
            self.techs = techs
            return self
        }

        @discardableResult
        public func addTech(_ tech: Tech) -> Builder {
            techs.append(tech)
            return self
        }

        @discardableResult
        public func withRole(_ role: Role) -> Builder {
            self.role = role
            return self
        }

        @discardableResult
        public func withCustomRole(title: String, seniority: Role.Seniority) -> Builder {
            role = Role(title: title, seniority: seniority)
            return self
        }

        @discardableResult
        public func withPeriod(_ period: Period) -> Builder {
            self.period = period
            return self
        }

        @discardableResult
        public func withPeriod(start: (month: Int, year: Int), end: (month: Int, year: Int)) -> Builder {
            period = Period(
                start: .init(month: start.month, year: start.year),
                end: .init(month: end.month, year: end.year),
            )
            return self
        }

        /// Marks the role as ongoing. An end date is still required (used for
        /// sorting), but renderers display the range as "... - Present".
        @discardableResult
        public func withCurrent(_ isCurrent: Bool = true) -> Builder {
            self.isCurrent = isCurrent
            return self
        }

        /// Attaches technical areas and tags to the concrete project.
        @discardableResult
        public func withTechnicalFocus(_ technicalFocus: TechnicalFocus?) -> Builder {
            self.technicalFocus = technicalFocus
            return self
        }

        @discardableResult
        public func withURLs(_ urls: [URL]?) -> Builder {
            self.urls = urls
            return self
        }

        @discardableResult
        public func addURL(_ url: URL) -> Builder {
            if urls == nil {
                urls = []
            }
            urls?.append(url)
            return self
        }

        public func build() throws -> Project {
            guard !name.isEmpty else {
                throw BuilderError.missingName
            }

            guard let company else {
                throw BuilderError.missingCompany
            }

            guard let period else {
                throw BuilderError.missingPeriod
            }

            return Project(
                id: id,
                name: name,
                company: company,
                descriptions: descriptions,
                techs: techs,
                role: role,
                period: period,
                urls: urls,
                isCurrent: isCurrent,
                technicalFocus: technicalFocus,
            )
        }

        public enum BuilderError: Error {
            case missingName
            case missingCompany
            case missingPeriod
        }
    }
}
