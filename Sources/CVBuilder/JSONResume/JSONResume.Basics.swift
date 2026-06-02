import Foundation

public extension JSONResume {
    /// JSON Resume `basics`: identity, contact data, and profile links.
    struct Basics: Codable, Equatable, Sendable {
        /// Full name.
        public let name: String
        /// Headline or role label, for example `Senior iOS Engineer`.
        public let label: String
        /// Contact email address.
        public let email: String
        /// Contact phone number.
        public let phone: String
        /// Personal or portfolio website URL.
        public let url: String
        /// Short professional summary.
        public let summary: String
        /// Structured location. Mapped to and from a single `CVDocument` location string.
        public let location: Location
        /// Public profile links such as LinkedIn or GitHub.
        public let profiles: [Profile]

        private enum CodingKeys: String, CodingKey {
            case name
            case label
            case email
            case phone
            case url
            case summary
            case location
            case profiles
        }

        public init(
            name: String = "",
            label: String = "",
            email: String = "",
            phone: String = "",
            url: String = "",
            summary: String = "",
            location: Location = .init(),
            profiles: [Profile] = [],
        ) {
            self.name = name
            self.label = label
            self.email = email
            self.phone = phone
            self.url = url
            self.summary = summary
            self.location = location
            self.profiles = profiles
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            name = try container.decode(String.self, forKey: .name, defaultIfMissing: "")
            label = try container.decode(String.self, forKey: .label, defaultIfMissing: "")
            email = try container.decode(String.self, forKey: .email, defaultIfMissing: "")
            phone = try container.decode(String.self, forKey: .phone, defaultIfMissing: "")
            url = try container.decode(String.self, forKey: .url, defaultIfMissing: "")
            summary = try container.decode(String.self, forKey: .summary, defaultIfMissing: "")
            location = try container.decode(Location.self, forKey: .location, defaultIfMissing: .init())
            profiles = try container.decode([Profile].self, forKey: .profiles, defaultIfMissing: [])
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfNotEmpty(name, forKey: .name)
            try container.encodeIfNotEmpty(label, forKey: .label)
            try container.encodeIfNotEmpty(email, forKey: .email)
            try container.encodeIfNotEmpty(phone, forKey: .phone)
            try container.encodeIfNotEmpty(url, forKey: .url)
            try container.encodeIfNotEmpty(summary, forKey: .summary)
            if location != Location() {
                try container.encode(location, forKey: .location)
            }
            try container.encodeIfNotEmpty(profiles, forKey: .profiles)
        }
    }
}

public extension JSONResume.Basics {
    /// JSON Resume `basics.location`: a structured postal location.
    struct Location: Codable, Equatable, Sendable {
        public let address: String
        public let postalCode: String
        public let city: String
        public let countryCode: String
        public let region: String

        private enum CodingKeys: String, CodingKey {
            case address
            case postalCode
            case city
            case countryCode
            case region
        }

        public init(
            address: String = "",
            postalCode: String = "",
            city: String = "",
            countryCode: String = "",
            region: String = "",
        ) {
            self.address = address
            self.postalCode = postalCode
            self.city = city
            self.countryCode = countryCode
            self.region = region
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            address = try container.decode(String.self, forKey: .address, defaultIfMissing: "")
            postalCode = try container.decode(String.self, forKey: .postalCode, defaultIfMissing: "")
            city = try container.decode(String.self, forKey: .city, defaultIfMissing: "")
            countryCode = try container.decode(String.self, forKey: .countryCode, defaultIfMissing: "")
            region = try container.decode(String.self, forKey: .region, defaultIfMissing: "")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfNotEmpty(address, forKey: .address)
            try container.encodeIfNotEmpty(postalCode, forKey: .postalCode)
            try container.encodeIfNotEmpty(city, forKey: .city)
            try container.encodeIfNotEmpty(countryCode, forKey: .countryCode)
            try container.encodeIfNotEmpty(region, forKey: .region)
        }
    }

    /// JSON Resume `basics.profiles` entry: a single public profile link.
    struct Profile: Codable, Equatable, Sendable {
        /// Network name such as `LinkedIn` or `GitHub`.
        public let network: String
        /// Account handle on the network.
        public let username: String
        /// Profile URL.
        public let url: String

        private enum CodingKeys: String, CodingKey {
            case network
            case username
            case url
        }

        public init(network: String = "", username: String = "", url: String = "") {
            self.network = network
            self.username = username
            self.url = url
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            network = try container.decode(String.self, forKey: .network, defaultIfMissing: "")
            username = try container.decode(String.self, forKey: .username, defaultIfMissing: "")
            url = try container.decode(String.self, forKey: .url, defaultIfMissing: "")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfNotEmpty(network, forKey: .network)
            try container.encodeIfNotEmpty(username, forKey: .username)
            try container.encodeIfNotEmpty(url, forKey: .url)
        }
    }
}
