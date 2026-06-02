import Foundation

/// The localizable strings the Markdown renderer emits for section headings,
/// field labels, connectors, category and evidence-kind names, and month
/// abbreviations.
///
/// A label set is selected through `RenderingOptions.locale`. The renderer never
/// reads the host `Locale` or `Calendar`, so output stays byte-for-byte
/// deterministic regardless of the machine it runs on. Section headings are the
/// heading text only; the renderer adds the `## ` prefix. Month names index by
/// calendar month (1 to 12); the renderer falls back to an ISO `YYYY-MM` form
/// for out-of-range months, independent of the label set.
public struct RenderingLabels: Equatable, Sendable {
    // Section headings.
    public let contact: String
    public let experience: String
    public let education: String
    public let publicEvidence: String
    public let skills: String
    public let links: String
    public let projects: String

    // Contact field labels.
    public let email: String
    public let phone: String
    public let location: String
    public let linkedIn: String
    public let github: String
    public let website: String

    // Entry field labels.
    public let role: String
    public let kind: String
    public let date: String
    public let period: String
    public let summary: String
    public let technologies: String
    public let technicalFocus: String
    public let technicalTags: String
    public let projectLinks: String

    // Connectors and tokens.
    public let present: String
    public let degreeFieldConnector: String

    // Skill category labels.
    public let categoryLanguages: String
    public let categoryFrameworks: String
    public let categoryTools: String
    public let categoryPlatforms: String
    public let categoryConcepts: String
    public let categoryOther: String
    public let categoryUncategorized: String

    // Public-evidence kind labels.
    public let kindOpenSource: String
    public let kindTalk: String
    public let kindPublication: String
    public let kindApp: String
    public let kindPackage: String
    public let kindTechnicalWriting: String
    public let kindProject: String
    public let kindOther: String

    /// Month abbreviations indexed 1 to 12.
    public let monthNames: [String]

    public init(
        contact: String,
        experience: String,
        education: String,
        publicEvidence: String,
        skills: String,
        links: String,
        projects: String,
        email: String,
        phone: String,
        location: String,
        linkedIn: String,
        github: String,
        website: String,
        role: String,
        kind: String,
        date: String,
        period: String,
        summary: String,
        technologies: String,
        technicalFocus: String,
        technicalTags: String,
        projectLinks: String,
        present: String,
        degreeFieldConnector: String,
        categoryLanguages: String,
        categoryFrameworks: String,
        categoryTools: String,
        categoryPlatforms: String,
        categoryConcepts: String,
        categoryOther: String,
        categoryUncategorized: String,
        kindOpenSource: String,
        kindTalk: String,
        kindPublication: String,
        kindApp: String,
        kindPackage: String,
        kindTechnicalWriting: String,
        kindProject: String,
        kindOther: String,
        monthNames: [String],
    ) {
        self.contact = contact
        self.experience = experience
        self.education = education
        self.publicEvidence = publicEvidence
        self.skills = skills
        self.links = links
        self.projects = projects
        self.email = email
        self.phone = phone
        self.location = location
        self.linkedIn = linkedIn
        self.github = github
        self.website = website
        self.role = role
        self.kind = kind
        self.date = date
        self.period = period
        self.summary = summary
        self.technologies = technologies
        self.technicalFocus = technicalFocus
        self.technicalTags = technicalTags
        self.projectLinks = projectLinks
        self.present = present
        self.degreeFieldConnector = degreeFieldConnector
        self.categoryLanguages = categoryLanguages
        self.categoryFrameworks = categoryFrameworks
        self.categoryTools = categoryTools
        self.categoryPlatforms = categoryPlatforms
        self.categoryConcepts = categoryConcepts
        self.categoryOther = categoryOther
        self.categoryUncategorized = categoryUncategorized
        self.kindOpenSource = kindOpenSource
        self.kindTalk = kindTalk
        self.kindPublication = kindPublication
        self.kindApp = kindApp
        self.kindPackage = kindPackage
        self.kindTechnicalWriting = kindTechnicalWriting
        self.kindProject = kindProject
        self.kindOther = kindOther
        self.monthNames = monthNames
    }
}

public extension RenderingLabels {
    /// English labels. These reproduce the renderer's original literals exactly,
    /// so default output stays byte-for-byte stable.
    static let english = RenderingLabels(
        contact: "Contact",
        experience: "Experience",
        education: "Education",
        publicEvidence: "Public Evidence",
        skills: "Skills",
        links: "Links",
        projects: "Projects",
        email: "Email",
        phone: "Phone",
        location: "Location",
        linkedIn: "LinkedIn",
        github: "GitHub",
        website: "Website",
        role: "Role",
        kind: "Kind",
        date: "Date",
        period: "Period",
        summary: "Summary",
        technologies: "Technologies",
        technicalFocus: "Technical focus",
        technicalTags: "Technical tags",
        projectLinks: "Links",
        present: "Present",
        degreeFieldConnector: " in ",
        categoryLanguages: "Languages",
        categoryFrameworks: "Frameworks",
        categoryTools: "Tools",
        categoryPlatforms: "Platforms",
        categoryConcepts: "Concepts",
        categoryOther: "Other",
        categoryUncategorized: "Uncategorized",
        kindOpenSource: "Open source",
        kindTalk: "Talk",
        kindPublication: "Publication",
        kindApp: "App",
        kindPackage: "Package",
        kindTechnicalWriting: "Technical writing",
        kindProject: "Project",
        kindOther: "Other",
        monthNames: [
            "Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
        ],
    )

    /// German labels. Brand names (LinkedIn, GitHub) and widely-used loanwords
    /// (App, Frameworks, Tags, Website) stay as-is by convention.
    static let german = RenderingLabels(
        contact: "Kontakt",
        experience: "Berufserfahrung",
        education: "Ausbildung",
        publicEvidence: "Öffentliche Nachweise",
        skills: "Kenntnisse",
        links: "Links",
        projects: "Projekte",
        email: "E-Mail",
        phone: "Telefon",
        location: "Standort",
        linkedIn: "LinkedIn",
        github: "GitHub",
        website: "Website",
        role: "Rolle",
        kind: "Art",
        date: "Datum",
        period: "Zeitraum",
        summary: "Zusammenfassung",
        technologies: "Technologien",
        technicalFocus: "Technischer Schwerpunkt",
        technicalTags: "Technische Tags",
        projectLinks: "Links",
        present: "Heute",
        degreeFieldConnector: " in ",
        categoryLanguages: "Sprachen",
        categoryFrameworks: "Frameworks",
        categoryTools: "Werkzeuge",
        categoryPlatforms: "Plattformen",
        categoryConcepts: "Konzepte",
        categoryOther: "Sonstiges",
        categoryUncategorized: "Nicht kategorisiert",
        kindOpenSource: "Open Source",
        kindTalk: "Vortrag",
        kindPublication: "Veröffentlichung",
        kindApp: "App",
        kindPackage: "Paket",
        kindTechnicalWriting: "Technische Dokumentation",
        kindProject: "Projekt",
        kindOther: "Sonstiges",
        monthNames: [
            "Jan", "Feb", "Mär", "Apr", "Mai", "Jun",
            "Jul", "Aug", "Sep", "Okt", "Nov", "Dez",
        ],
    )
}
