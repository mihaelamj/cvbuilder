import Foundation

public struct Period: Codable, Identifiable, Equatable, Hashable {
    
    public struct SimpleDate: Codable, Identifiable, Hashable, Equatable {
        
        public let month: Int
        public let year: Int
        
        public var id: String {
            "\(year)-\(String(format: "%02d", month))"
        }
        
        public init(month: Int, year: Int) {
            self.month = month
            self.year = year
        }
    }

    public let start: SimpleDate
    public let end: SimpleDate
    
    var formattedDateRange: String {
        return "\(start.month)/\(start.year) - \(end.month)/\(end.year)"
    }

    public var id: String {
        "\(start.id)_to_\(end.id)"
    }
    
    public init(start: Period.SimpleDate, end: Period.SimpleDate) {
        self.start = start
        self.end = end
    }
}

// Add Comparable conformance to SimpleDate
extension Period.SimpleDate: Comparable {
    public static func < (lhs: Period.SimpleDate, rhs: Period.SimpleDate) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        }
        return lhs.month < rhs.month
    }
    
    public static func == (lhs: Period.SimpleDate, rhs: Period.SimpleDate) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month
    }
}
