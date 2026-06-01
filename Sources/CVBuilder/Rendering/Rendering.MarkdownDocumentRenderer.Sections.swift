import Foundation

extension Rendering.MarkdownDocumentRenderer {
    enum Section: Equatable {
        case contact
        case experience
        case education
        case publicEvidence
        case skills
        case links
    }

    struct Writer {
        private(set) var output = ""

        mutating func block(_ lines: [String]) {
            let content = lines
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .joined(separator: "\n")

            guard !content.isEmpty else {
                return
            }

            if !output.isEmpty {
                output += "\n\n"
            }
            output += content
        }
    }
}

extension Rendering.MarkdownDocumentRenderer {
    func sections(for mode: RenderingMode) -> [Section] {
        policy(for: mode).sections
    }

    func renderFrontMatter(_ frontMatter: [String: String], writer: inout Writer) {
        guard !frontMatter.isEmpty else {
            return
        }

        let lines = frontMatter.keys.sorted().map { key in
            "\(escapedFrontMatterKey(key)): \(escapedFrontMatterScalar(frontMatter[key] ?? ""))"
        }
        writer.block(["---"] + lines + ["---"])
    }

    func renderHeader(_ resume: CV, writer: inout Writer) {
        writer.block([
            "# \(escapedMarkdownText(resume.name))",
            escapedMarkdownText(resume.title),
            escapedMarkdownText(resume.summary),
        ])
    }

    func renderContact(_ contactInfo: ContactInfo, writer: inout Writer) {
        var lines: [String] = []
        appendLine("Email", value: contactInfo.email, to: &lines)
        appendLine("Phone", value: contactInfo.phone, to: &lines)
        appendLine("Location", value: contactInfo.location, to: &lines)
        appendLinkLine("LinkedIn", url: contactInfo.linkedIn?.absoluteString, to: &lines)
        appendLinkLine("GitHub", url: contactInfo.github?.absoluteString, to: &lines)
        appendLinkLine("Website", url: contactInfo.website?.absoluteString, to: &lines)

        guard !lines.isEmpty else {
            return
        }

        writer.block(["## Contact"] + lines)
    }

    func renderExperience(
        _ experience: [WorkExperience],
        links: DocumentLinks,
        options: RenderingOptions,
        writer: inout Writer,
    ) {
        let visibleExperience = limitedExperience(experience, recentCompanyCount: options.recentCompanyCount)
        guard !visibleExperience.isEmpty else {
            renderEmptySection("## Experience", options: options, writer: &writer)
            return
        }

        var lines = ["## Experience"]
        for work in visibleExperience {
            lines.append("### \(workHeading(work, links: links))")
            lines.append(format(work.period, isCurrent: work.isCurrent))
            appendFocus(work.technicalFocus, to: &lines)

            if options.nestProjectsUnderRoles {
                appendNestedProjects(work.projects, options: options, to: &lines)
            }
        }

        if !options.nestProjectsUnderRoles {
            appendStandaloneProjects(from: visibleExperience, options: options, to: &lines)
        }

        writer.block(lines)
    }

    func renderEducation(_ education: [Education], options: RenderingOptions, writer: inout Writer) {
        guard !education.isEmpty else {
            renderEmptySection("## Education", options: options, writer: &writer)
            return
        }

        var lines = ["## Education"]
        for item in education {
            lines.append("### \(escapedMarkdownText(item.institution))")
            lines.append("\(escapedMarkdownText(item.degree)) in \(escapedMarkdownText(item.field))")
            lines.append(format(item.period, isCurrent: false))
        }

        writer.block(lines)
    }

    func renderPublicEvidence(_ evidence: [PublicEvidence], options: RenderingOptions, writer: inout Writer) {
        guard !evidence.isEmpty else {
            renderEmptySection("## Public Evidence", options: options, writer: &writer)
            return
        }

        var lines = ["## Public Evidence"]
        for item in evidence {
            lines.append("### \(linkedText(item.title, destination: item.url))")
            lines.append("Kind: \(label(for: item.kind))")
            appendLine("Role", value: item.role, to: &lines)
            appendEvidenceDate(item, to: &lines)
            appendLine("Summary", value: item.summary, to: &lines)
            appendLabelledList("Technologies", values: item.technologies, to: &lines)
            appendFocus(item.technicalFocus, to: &lines)
            appendHighlights(item.highlights, to: &lines)
        }

        writer.block(lines)
    }

    func renderSkills(_ skills: [Tech], options: RenderingOptions, writer: inout Writer) {
        guard !skills.isEmpty else {
            renderEmptySection("## Skills", options: options, writer: &writer)
            return
        }

        var lines = ["## Skills"]
        if options.compactGroupedSkills {
            for category in orderedSkillCategories(skills) {
                let categorySkills = skills.filter { $0.category == category }.map(\.name)
                appendLabelledList(label(for: category), values: categorySkills, to: &lines)
            }
        } else {
            for skill in skills {
                lines.append(escapedMarkdownText(skill.name))
            }
        }

        writer.block(lines)
    }

    func renderLinks(_ links: DocumentLinks, options: RenderingOptions, writer: inout Writer) {
        let documentLinks = links.profiles + links.downloads
        guard !documentLinks.isEmpty else {
            renderEmptySection("## Links", options: options, writer: &writer)
            return
        }

        var lines = ["## Links"]
        for link in documentLinks {
            lines.append(linkedText(link.label, destination: link.url))
        }

        writer.block(lines)
    }

    func renderEmptySection(_ heading: String, options: RenderingOptions, writer: inout Writer) {
        guard !options.omitEmptySections else {
            return
        }

        writer.block([heading])
    }
}

extension Rendering.MarkdownDocumentRenderer {
    func appendNestedProjects(
        _ projects: [ProjectExperience],
        options: RenderingOptions,
        to lines: inout [String],
    ) {
        for projectExperience in projects {
            appendProject(projectExperience, headingLevel: "####", options: options, to: &lines)
        }
    }

    func appendStandaloneProjects(
        from experience: [WorkExperience],
        options: RenderingOptions,
        to lines: inout [String],
    ) {
        let projects = experience.flatMap(\.projects)
        guard !projects.isEmpty else {
            return
        }

        lines.append("## Projects")
        for projectExperience in projects {
            appendProject(projectExperience, headingLevel: "###", options: options, to: &lines)
        }
    }

    func appendProject(
        _ projectExperience: ProjectExperience,
        headingLevel: String,
        options: RenderingOptions,
        to lines: inout [String],
    ) {
        let project = projectExperience.project
        lines.append("\(headingLevel) \(escapedMarkdownText(project.name))")
        lines.append(format(projectExperience.period, isCurrent: project.isCurrent))
        appendLine("Role", value: projectExperience.role.name, to: &lines)

        for description in limitedDescriptions(project.descriptions, maxCount: options.maxBulletsPerProject) {
            appendParagraph(description, to: &lines)
        }

        appendLabelledList("Technologies", values: project.techs.map(\.name), to: &lines)
        appendFocus(projectExperience.technicalFocus, project.technicalFocus, to: &lines)
        appendProjectLinks(project.urls, to: &lines)
    }

    func appendProjectLinks(_ urls: [URL]?, to lines: inout [String]) {
        guard let urls, !urls.isEmpty else {
            return
        }

        let renderedURLs = urls.map { linkedText($0.absoluteString, destination: $0.absoluteString) }
        lines.append("Links: \(renderedURLs.joined(separator: ", "))")
    }

    func appendEvidenceDate(_ evidence: PublicEvidence, to lines: inout [String]) {
        if let date = evidence.date?.trimmingCharacters(in: .whitespacesAndNewlines), !date.isEmpty {
            appendLine("Date", value: date, to: &lines)
        } else if let period = evidence.period {
            lines.append("Period: \(format(period, isCurrent: false))")
        }
    }

    func appendHighlights(_ highlights: [String], to lines: inout [String]) {
        for highlight in highlights {
            let trimmedHighlight = highlight.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedHighlight.isEmpty else {
                continue
            }

            lines.append(escapedMarkdownText(trimmedHighlight))
        }
    }
}
