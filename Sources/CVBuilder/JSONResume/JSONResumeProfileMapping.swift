import Foundation

/// Maps JSON Resume `basics.profiles` to and from the split `CVDocument` model.
///
/// LinkedIn and GitHub profiles become typed `ContactInfo` URLs; every other
/// profile becomes a document `Link`. Export emits LinkedIn first, then GitHub,
/// then the remaining document links in order, using the canonical network
/// names `LinkedIn` and `GitHub`. Profile `username` is not represented in
/// `CVDocument` and is dropped in both directions.
enum JSONResumeProfileMapping {
    /// A profile network that maps onto a typed `ContactInfo` field.
    enum RecognizedNetwork: String {
        case linkedIn = "LinkedIn"
        case gitHub = "GitHub"

        /// Whether a profile `network` string names this recognized network.
        func matches(_ network: String) -> Bool {
            network.lowercased() == rawValue.lowercased()
        }
    }

    /// Returns the first profile URL whose network matches, parsed as a `URL`.
    static func url(in profiles: [JSONResume.Basics.Profile], matching network: RecognizedNetwork) -> URL? {
        guard
            let profile = profiles.first(where: { network.matches($0.network) }),
            !profile.url.isEmpty
        else {
            return nil
        }

        return URL(string: profile.url)
    }

    /// Maps profiles that are not LinkedIn or GitHub onto document `Link` values.
    static func documentLinks(from profiles: [JSONResume.Basics.Profile]) -> [Link] {
        profiles
            .filter { profile in
                !RecognizedNetwork.linkedIn.matches(profile.network)
                    && !RecognizedNetwork.gitHub.matches(profile.network)
            }
            .map { Link(label: $0.network, url: $0.url) }
    }

    /// Rebuilds the canonical profile list from typed contact data and document links.
    static func profiles(contactInfo: ContactInfo, links: DocumentLinks) -> [JSONResume.Basics.Profile] {
        var profiles: [JSONResume.Basics.Profile] = []

        if let linkedIn = contactInfo.linkedIn {
            profiles.append(.init(network: RecognizedNetwork.linkedIn.rawValue, url: linkedIn.absoluteString))
        }

        if let github = contactInfo.github {
            profiles.append(.init(network: RecognizedNetwork.gitHub.rawValue, url: github.absoluteString))
        }

        profiles.append(contentsOf: links.profiles.map { .init(network: $0.label, url: $0.url) })

        return profiles
    }
}
