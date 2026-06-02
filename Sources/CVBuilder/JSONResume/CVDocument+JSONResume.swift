import Foundation

public extension JSONResume {
    /// Builds a JSON Resume document from a `CVDocument`.
    ///
    /// `cv.experience` becomes JSON Resume `work` (a role's nested-project
    /// descriptions are flattened into `summary` and `highlights`),
    /// `publicEvidence` becomes JSON Resume `projects`, and contact, profile,
    /// education, and skill data map onto their JSON Resume equivalents.
    ///
    /// This direction is lossy: per-project structure, seniority nuance beyond
    /// the role name, technical focus, rendering options, front matter, and
    /// identifiers have no JSON Resume representation. See
    /// the JSONResumeInterop catalog article for the inventory.
    init(cvDocument document: CVDocument) {
        let cv = document.cv

        let basics = Basics(
            name: cv.name,
            label: cv.title,
            email: cv.contactInfo.email,
            phone: cv.contactInfo.phone,
            url: cv.contactInfo.website?.absoluteString ?? "",
            summary: cv.summary,
            location: Basics.Location(city: cv.contactInfo.location),
            profiles: JSONResumeProfileMapping.profiles(contactInfo: cv.contactInfo, links: document.links),
        )

        self.init(
            basics: basics,
            work: cv.experience.map { Work(workExperience: $0, companyURLs: document.links.companyURLs) },
            education: cv.education.map(Education.init(education:)),
            skills: cv.skills.map { Skill(name: $0.name) },
            projects: document.publicEvidence.map(Project.init(publicEvidence:)),
        )
    }
}

extension JSONResume.Work {
    init(workExperience work: WorkExperience, companyURLs: [String: String]) {
        let descriptions = work.projects.flatMap(\.project.descriptions)

        self.init(
            name: work.company.name,
            position: JSONResumeSeniority.position(seniority: work.role.seniority, title: work.role.title),
            url: companyURLs[work.company.name] ?? "",
            startDate: JSONResumeDate.string(from: work.period.start),
            endDate: work.isCurrent ? "" : JSONResumeDate.string(from: work.period.end),
            summary: descriptions.first ?? "",
            highlights: Array(descriptions.dropFirst()),
        )
    }
}

extension JSONResume.Education {
    init(education: Education) {
        self.init(
            institution: education.institution,
            area: education.field,
            studyType: education.degree,
            startDate: JSONResumeDate.string(from: education.period.start),
            endDate: JSONResumeDate.string(from: education.period.end),
        )
    }
}

extension JSONResume.Project {
    init(publicEvidence evidence: PublicEvidence) {
        let startDate: String
        let endDate: String
        if let period = evidence.period {
            startDate = JSONResumeDate.string(from: period.start)
            endDate = JSONResumeDate.string(from: period.end)
        } else {
            startDate = ""
            endDate = ""
        }

        self.init(
            name: evidence.title,
            description: evidence.summary,
            highlights: evidence.highlights,
            keywords: evidence.technologies,
            startDate: startDate,
            endDate: endDate,
            url: evidence.url,
            roles: evidence.role.isEmpty ? [] : [evidence.role],
            type: evidence.kind.jsonResumeType,
        )
    }
}
