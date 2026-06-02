import Foundation

/// A typed model of a [jsonresume.org](https://jsonresume.org) document.
///
/// Only the sections that map cleanly to `CVDocument` are modelled: `basics`,
/// `work`, `education`, `skills`, and `projects`. Other JSON Resume sections
/// (`volunteer`, `awards`, `publications`, `languages`, and so on) are ignored
/// on import and never emitted on export.
///
/// The model is a faithful, lossless representation of the JSON Resume schema
/// for those sections. Mapping logic and the lossy-field inventory live in the
/// conversion extensions (`JSONResume+CVDocument` for import and
/// `CVDocument+JSONResume` for export) and in `docs/json-resume-interop.md`.
public struct JSONResume: Codable, Equatable, Sendable {
    /// Identity, contact data, and public profile links.
    public let basics: Basics
    /// Flat work history. Each entry maps to one `WorkExperience`.
    public let work: [Work]
    /// Education history.
    public let education: [Education]
    /// Flat skill list. Each entry maps to one or more `Tech` values.
    public let skills: [Skill]
    /// Standalone projects. Each entry maps to one `PublicEvidence` item.
    public let projects: [Project]
    /// Optional document metadata such as `version` and `canonical`.
    public let meta: Meta?

    private enum CodingKeys: String, CodingKey {
        case basics
        case work
        case education
        case skills
        case projects
        case meta
    }

    public init(
        basics: Basics = .init(),
        work: [Work] = [],
        education: [Education] = [],
        skills: [Skill] = [],
        projects: [Project] = [],
        meta: Meta? = nil,
    ) {
        self.basics = basics
        self.work = work
        self.education = education
        self.skills = skills
        self.projects = projects
        self.meta = meta
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        basics = try container.decode(Basics.self, forKey: .basics, defaultIfMissing: .init())
        work = try container.decode([Work].self, forKey: .work, defaultIfMissing: [])
        education = try container.decode([Education].self, forKey: .education, defaultIfMissing: [])
        skills = try container.decode([Skill].self, forKey: .skills, defaultIfMissing: [])
        projects = try container.decode([Project].self, forKey: .projects, defaultIfMissing: [])
        meta = try container.decodeIfPresent(Meta.self, forKey: .meta)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(basics, forKey: .basics)
        try container.encodeIfNotEmpty(work, forKey: .work)
        try container.encodeIfNotEmpty(education, forKey: .education)
        try container.encodeIfNotEmpty(skills, forKey: .skills)
        try container.encodeIfNotEmpty(projects, forKey: .projects)
        try container.encodeIfPresent(meta, forKey: .meta)
    }
}
