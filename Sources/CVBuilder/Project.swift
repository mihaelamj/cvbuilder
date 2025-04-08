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
    
    public init(
        id: UUID = UUID(),
        name: String,
        company: Company,
        descriptions: [String],
        techs: [Tech],
        role: Role,
        period: Period,
        urls: [URL]? = nil
    ) {
        self.id = id
        self.name = name
        self.company = company
        self.descriptions = descriptions
        self.techs = techs
        self.role = role
        self.period = period
        self.urls = urls
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
                urls: urls
            )
        }
        
        public enum BuilderError: Error {
            case missingName
            case missingCompany
            case missingPeriod
        }
    }
}
