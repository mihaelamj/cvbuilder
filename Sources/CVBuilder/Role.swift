import Foundation

public struct Role: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID?
    public let title: String
    public let seniority: Seniority

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case seniority
    }

    public init(id: UUID? = nil, title: String, seniority: Seniority) {
        self.id = id
        self.title = title
        self.seniority = seniority
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeOmittable(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        seniority = try container.decode(Seniority.self, forKey: .seniority)
    }

    /// For backward compatibility with existing code using the role.name
    public var name: String {
        "\(seniority.rawValue) \(title)"
    }

    /// Seniority level enum (can be extended)
    public enum Seniority: String, Codable, Comparable, Sendable {
        case intern = "Intern"
        case junior = "Junior"
        case mid = "Mid"
        case senior = "Senior"
        case lead = "Lead"
        case principal = "Principal"
        case chief = "Chief"

        /// Support for comparing seniority levels
        public static func < (lhs: Seniority, rhs: Seniority) -> Bool {
            lhs.rank < rhs.rank
        }

        public var rank: Int {
            switch self {
            case .intern: 0
            case .junior: 1
            case .mid: 2
            case .senior: 3
            case .lead: 4
            case .principal: 5
            case .chief: 6
            }
        }
    }

    /// Common role factory methods
    public static let none = Role(title: "Unknown", seniority: .junior)

    /// Helper to compare roles by seniority
    public static func hasHigherSeniority(_ role1: Role, than role2: Role) -> Bool {
        role1.seniority > role2.seniority
    }
}

/// Extension to support the CV.rank function from the original code
public extension CV {
    static func rank(_ role: Role) -> Int {
        role.seniority.rank
    }
}
