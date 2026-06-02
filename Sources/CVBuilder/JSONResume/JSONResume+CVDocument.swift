import Foundation

public extension CVDocument {
    /// Builds a `CVDocument` from a JSON Resume document.
    ///
    /// JSON Resume `work` entries become `cv.experience`, with each entry's
    /// `summary` and `highlights` carried on a single synthesized nested project
    /// so the renderer can show them. JSON Resume `projects` become
    /// `publicEvidence` items. Profile, contact, education, and skill data map
    /// onto their `CVDocument` equivalents. Fields with no `CVDocument` home are
    /// dropped; see `docs/json-resume-interop.md` for the full inventory.
    init(jsonResume resume: JSONResume) {
        let cv = CV(jsonResume: resume)

        var companyURLs: [String: String] = [:]
        for work in resume.work where !work.url.isEmpty {
            companyURLs[work.name] = work.url
        }

        let links = DocumentLinks(
            profiles: JSONResumeProfileMapping.documentLinks(from: resume.basics.profiles),
            companyURLs: companyURLs,
        )

        let evidence = resume.projects.map(PublicEvidence.init(jsonResumeProject:))

        self.init(cv: cv, links: links, publicEvidence: evidence)
    }
}

extension CV {
    init(jsonResume resume: JSONResume) {
        let basics = resume.basics

        self.init(
            name: basics.name,
            title: basics.label,
            summary: basics.summary,
            contactInfo: ContactInfo(jsonResumeBasics: basics),
            experience: resume.work.map(WorkExperience.init(jsonResumeWork:)),
            education: resume.education.map(Education.init(jsonResume:)),
            skills: resume.skills.flatMap(\.cvTechs),
        )
    }
}

extension ContactInfo {
    init(jsonResumeBasics basics: JSONResume.Basics) {
        self.init(
            email: basics.email,
            phone: basics.phone,
            linkedIn: JSONResumeProfileMapping.url(in: basics.profiles, matching: .linkedIn),
            github: JSONResumeProfileMapping.url(in: basics.profiles, matching: .gitHub),
            website: basics.url.isEmpty ? nil : URL(string: basics.url),
            location: Self.composedLocation(basics.location),
        )
    }

    static func composedLocation(_ location: JSONResume.Basics.Location) -> String {
        let parts = [location.city, location.region, location.countryCode].filter { !$0.isEmpty }
        guard parts.isEmpty else {
            return parts.joined(separator: ", ")
        }

        return location.address
    }
}

extension WorkExperience {
    init(jsonResumeWork work: JSONResume.Work) {
        let (seniority, title) = JSONResumeSeniority.split(position: work.position)
        let company = Company(name: work.name)
        let role = Role(title: title, seniority: seniority)
        let isCurrent = work.endDate.trimmingCharacters(in: .whitespaces).isEmpty

        let start = JSONResumeDate.simpleDate(from: work.startDate) ?? Period.SimpleDate(month: 1, year: 1)
        let end = isCurrent ? start : (JSONResumeDate.simpleDate(from: work.endDate) ?? start)
        let period = Period(start: start, end: end)

        let descriptions = (work.summary.isEmpty ? [] : [work.summary]) + work.highlights
        let projects: [ProjectExperience]
        if descriptions.isEmpty {
            projects = []
        } else {
            let project = Project(
                name: work.position,
                company: company,
                descriptions: descriptions,
                techs: [],
                role: role,
                period: period,
                isCurrent: isCurrent,
            )
            projects = [ProjectExperience(project: project, role: role, period: period)]
        }

        self.init(
            company: company,
            role: role,
            period: period,
            projects: projects,
            isCurrent: isCurrent,
        )
    }
}

extension Education {
    init(jsonResume education: JSONResume.Education) {
        let start = JSONResumeDate.simpleDate(from: education.startDate) ?? Period.SimpleDate(month: 1, year: 1)
        let end = JSONResumeDate.simpleDate(from: education.endDate) ?? start

        self.init(
            institution: education.institution,
            degree: education.studyType,
            field: education.area,
            period: Period(start: start, end: end),
        )
    }
}

extension PublicEvidence {
    init(jsonResumeProject project: JSONResume.Project) {
        let period: Period?
        if let start = JSONResumeDate.simpleDate(from: project.startDate) {
            let end = JSONResumeDate.simpleDate(from: project.endDate) ?? start
            period = Period(start: start, end: end)
        } else {
            period = nil
        }

        self.init(
            title: project.name,
            kind: PublicEvidenceKind(jsonResumeType: project.type),
            role: project.roles.first ?? "",
            summary: project.description,
            url: project.url,
            technologies: project.keywords,
            period: period,
            highlights: project.highlights,
        )
    }
}

extension JSONResume.Skill {
    /// Expands a JSON Resume skill into one `Tech` per competency.
    ///
    /// A skill with `keywords` is treated as a grouping: each keyword becomes a
    /// `Tech` and the group `name` is dropped. A skill with only a `name`
    /// becomes a single `Tech`. The grouping case is lossy in the export
    /// direction.
    var cvTechs: [Tech] {
        if !keywords.isEmpty {
            return keywords.map { Tech(name: $0) }
        }

        guard name.isEmpty else {
            return [Tech(name: name)]
        }

        return []
    }
}

extension PublicEvidenceKind {
    init(jsonResumeType type: String) {
        self = PublicEvidenceKind(rawValue: type) ?? .project
    }

    var jsonResumeType: String {
        rawValue
    }
}
