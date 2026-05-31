import Foundation

public struct Project: Codable, Identifiable, Hashable {
    public let id: UUID
    public let name: String
    public let company: Company
    public let descriptions: [String]
    public let techs: [Tech]
    public let role: Role
    public let period: Period
    public let urls: [URL]?
    public let isCurrent: Bool

    public init(
        id: UUID = UUID(),
        name: String,
        company: Company,
        descriptions: [String],
        techs: [Tech],
        role: Role,
        period: Period,
        urls: [URL]? = nil,
        isCurrent: Bool = false
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
    }

    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try c.decode(String.self, forKey: .name)
        company = try c.decode(Company.self, forKey: .company)
        descriptions = try c.decodeIfPresent([String].self, forKey: .descriptions) ?? []
        techs = try c.decodeIfPresent([Tech].self, forKey: .techs) ?? []
        role = try c.decode(Role.self, forKey: .role)
        period = try c.decode(Period.self, forKey: .period)
        urls = try c.decodeIfPresent([URL].self, forKey: .urls)
        isCurrent = try c.decodeIfPresent(Bool.self, forKey: .isCurrent) ?? false
    }

    public class Builder {
        private var id: UUID = UUID()
        private var name: String = ""
        private var company: Company? = nil
        private var descriptions: [String] = []
        private var techs: [Tech] = []
        private var role: Role = Role.none
        private var period: Period? = nil
        private var urls: [URL]? = nil
        private var isCurrent: Bool = false

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
            self.descriptions.append(description)
            return self
        }
        
        @discardableResult
        public func withTechs(_ techs: [Tech]) -> Builder {
            self.techs = techs
            return self
        }
        
        @discardableResult
        public func addTech(_ tech: Tech) -> Builder {
            self.techs.append(tech)
            return self
        }
        
        @discardableResult
        public func withRole(_ role: Role) -> Builder {
            self.role = role
            return self
        }
        
        @discardableResult
        public func withCustomRole(title: String, seniority: Role.Seniority) -> Builder {
            self.role = Role(title: title, seniority: seniority)
            return self
        }
        
        @discardableResult
        public func withPeriod(_ period: Period) -> Builder {
            self.period = period
            return self
        }
        
        @discardableResult
        public func withPeriod(start: (month: Int, year: Int), end: (month: Int, year: Int)) -> Builder {
            self.period = Period(
                start: .init(month: start.month, year: start.year),
                end: .init(month: end.month, year: end.year)
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

        @discardableResult
        public func withURLs(_ urls: [URL]?) -> Builder {
            self.urls = urls
            return self
        }
        
        @discardableResult
        public func addURL(_ url: URL) -> Builder {
            if self.urls == nil {
                self.urls = []
            }
            self.urls?.append(url)
            return self
        }
        
        public func build() throws -> Project {
            guard !name.isEmpty else {
                throw BuilderError.missingName
            }
            
            guard let company = company else {
                throw BuilderError.missingCompany
            }
            
            guard let period = period else {
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
                isCurrent: isCurrent
            )
        }
        
        public enum BuilderError: Error {
            case missingName
            case missingCompany
            case missingPeriod
        }
    }
}
