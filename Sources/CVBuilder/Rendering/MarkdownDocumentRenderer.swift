import Foundation

/// Renders a whole `CVDocument` (resume plus speaking, open source, links, and
/// front matter) to Markdown, the rich page real sites publish. Unlike
/// `MarkdownCVRenderer`, which renders only the core `CV`, this is the renderer a
/// website's CV page is generated from.
public struct MarkdownDocumentRenderer: Sendable {
    public init() {}

    public func render(_ document: CVDocument) -> String {
        var out = ""
        out += frontMatter(document.frontMatter)
        out += header(document.cv)
        out += contact(document.cv.contactInfo, links: document.links)
        out += education(document.cv.education)
        out += experience(document.cv.experience, links: document.links, options: document.rendering)
        out += openSource(document.openSource)
        out += speaking(document.speaking)
        out += skills(document.cv.skills)
        out += "---\n\n*Created with [CVBuilder](https://github.com/mihaelamj/cvbuilder)*\n"
        return out
    }

    private func frontMatter(_ values: [String: String]) -> String {
        guard !values.isEmpty else { return "" }
        var out = "---\n"
        // Sorted for deterministic output (so `--check` is stable).
        for key in values.keys.sorted() {
            out += "\(key): \(values[key] ?? "")\n"
        }
        out += "---\n\n"
        return out
    }

    private func header(_ cv: CV) -> String {
        "# \(cv.name)\n## \(cv.title)\n\n\(cv.summary)\n\n"
    }

    private func contact(_ contact: ContactInfo, links: DocumentLinks) -> String {
        var out = "**Contact:**\n"
        out += "- Email: \(contact.email)\n"
        out += "- Phone: \(contact.phone)\n"
        out += "- Location: \(contact.location)\n"
        if let linkedIn = contact.linkedIn { out += "- [LinkedIn](\(linkedIn.absoluteString))\n" }
        if let github = contact.github { out += "- [GitHub](\(github.absoluteString))\n" }
        if let twitter = links.twitter { out += "- [X/Twitter](\(twitter.absoluteString))\n" }
        if let website = contact.website { out += "- [Blog](\(website.absoluteString))\n" }
        if let pdf = links.resumePDF { out += "- [Download CV (PDF)](\(pdf))\n" }
        return out + "\n"
    }

    private func education(_ education: [Education]) -> String {
        guard !education.isEmpty else { return "" }
        var out = "**Education:**\n"
        for edu in education {
            out += "- \(edu.degree) in \(edu.field)\n"
            out += "- \(edu.institution)\n"
        }
        return out + "\n"
    }

    private func experience(
        _ experience: [WorkExperience],
        links: DocumentLinks,
        options: RenderingOptions
    ) -> String {
        let sorted = experience.sorted { $0.period.end > $1.period.end }
        let recentCount = options.recentCompanyCount ?? sorted.count
        let recent = sorted.prefix(recentCount)
        let earlier = sorted.dropFirst(recentCount)

        var out = "## EXPERIENCE\n\n"
        for exp in recent {
            let name = exp.company.name
            if let url = links.companyURLs[name] {
                out += "### [\(name)](\(url.absoluteString)) (\(range(exp.period))), \(exp.role.title)\n\n"
            } else {
                out += "### \(name) (\(range(exp.period))), \(exp.role.title)\n\n"
            }
            for projectExp in exp.projects.sorted(by: { $0.period.start > $1.period.start }) {
                let project = projectExp.project
                out += "#### \(project.name)\n"
                let bullets = options.maxBulletsPerProject.map { project.descriptions.prefix($0) }
                    ?? project.descriptions.prefix(project.descriptions.count)
                for desc in bullets { out += "- \(desc)\n" }
                if let urls = project.urls {
                    for url in urls { out += "- [\(url.absoluteString)](\(url.absoluteString))\n" }
                }
                out += "\n**Technologies:** \(project.techs.map(\.name).joined(separator: ", "))\n\n"
            }
        }

        if !earlier.isEmpty {
            out += "## EARLIER EXPERIENCE\n\n"
            for exp in earlier {
                out += "- **\(exp.company.name)** (\(range(exp.period))), \(exp.role.title)\n"
            }
            out += "\n"
        }
        return out
    }

    private func openSource(_ projects: [OpenSourceProject]) -> String {
        guard !projects.isEmpty else { return "" }
        var out = "## OPEN SOURCE\n\n"
        for osp in projects {
            out += "### [\(osp.name)](\(osp.url.absoluteString))\n"
            out += "- \(osp.description)\n\n"
            out += "**Technologies:** \(osp.techs.joined(separator: ", "))\n\n"
        }
        return out
    }

    private func speaking(_ engagements: [SpeakingEngagement]) -> String {
        guard !engagements.isEmpty else { return "" }
        var out = "## SPEAKING\n\n"
        for talk in engagements {
            out += "### \(talk.event) (\(talk.date)), \(talk.role)\n"
            out += "- \"\(talk.title)\"\n"
            out += "- \(talk.location)\n"
            if let site = talk.website { out += "- [\(site.label)](\(site.url.absoluteString))\n" }
            if let recording = talk.recordingURL { out += "- [Talk recording](\(recording.absoluteString))\n" }
            out += "\n"
        }
        return out
    }

    private func skills(_ skills: [Tech]) -> String {
        guard !skills.isEmpty else { return "" }
        return "## SKILLS\n\n\(skills.map(\.name).joined(separator: " | "))\n\n"
    }

    /// A `MM/yyyy - MM/yyyy` range from a `Period`.
    private func range(_ period: Period) -> String {
        "\(period.start.month)/\(period.start.year) - \(period.end.month)/\(period.end.year)"
    }
}
