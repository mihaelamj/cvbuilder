import Foundation

public struct Role: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let seniority: Seniority
    
    public init(id: UUID = UUID(), title: String, seniority: Seniority) {
        self.id = id
        self.title = title
        self.seniority = seniority
    }
    
    // For backward compatibility with existing code using the role.name
    public var name: String {
        return "\(seniority.rawValue) \(title)"
    }
    
    // Seniority level enum (can be extended)
    public enum Seniority: String, Codable, Comparable, Sendable {
        case intern = "Intern"
        case junior = "Junior"
        case mid = "Mid"
        case senior = "Senior"
        case lead = "Lead"
        case principal = "Principal"
        case chief = "Chief"
        
        // Support for comparing seniority levels
        public static func < (lhs: Seniority, rhs: Seniority) -> Bool {
            return lhs.rank < rhs.rank
        }
        
        public var rank: Int {
            switch self {
            case .intern: return 0
            case .junior: return 1
            case .mid: return 2
            case .senior: return 3
            case .lead: return 4
            case .principal: return 5
            case .chief: return 6
            }
        }
    }
    
    // Common role factory methods
    public static let none = Role(title: "Unknown", seniority: .junior)
//    public static let midIOS = Role(title: "iOS Developer", seniority: .mid)
//    public static let seniorIOS = Role(title: "iOS Developer", seniority: .senior)
//    public static let leadIOS = Role(title: "iOS Developer", seniority: .lead)
    
    // Helper to compare roles by seniority
    public static func hasHigherSeniority(_ role1: Role, than role2: Role) -> Bool {
        return role1.seniority > role2.seniority
    }
}

// Extension to support the CV.rank function from the original code
public extension CV {
    static func rank(_ role: Role) -> Int {
        return role.seniority.rank
    }
}
