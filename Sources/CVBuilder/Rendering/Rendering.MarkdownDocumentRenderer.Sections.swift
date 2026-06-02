import Foundation

extension Rendering.MarkdownDocumentRenderer {
    enum Section: Equatable {
        case contact
        case experience
        case projects
        case education
        case publicEvidence
        case skills
        case links
    }

    struct Writer {
        private(set) var output = ""

        mutating func block(_ lines: [String]) {
            let visibleLines = lines.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            let content = visibleLines.joined(separator: "\n")

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

    func renderFrontMatter(
        _ frontMatter: [String: String],
        profile: FrontMatterProfile,
        writer: inout Writer,
    ) {
        guard !frontMatter.isEmpty else {
            return
        }

        writer.block(frontMatterBlock(frontMatter, profile: profile))
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
        appendLine(labels.email, value: contactInfo.email, to: &lines)
        appendLine(labels.phone, value: contactInfo.phone, to: &lines)
        appendLine(labels.location, value: contactInfo.location, to: &lines)
        appendLinkLine(labels.linkedIn, url: contactInfo.linkedIn?.absoluteString, to: &lines)
        appendLinkLine(labels.github, url: contactInfo.github?.absoluteString, to: &lines)
        appendLinkLine(labels.website, url: contactInfo.website?.absoluteString, to: &lines)

        guard !lines.isEmpty else {
            return
        }

        writer.block(["## \(labels.contact)"] + lines)
    }

    func renderExperience(
        _ experience: [WorkExperience],
        links: DocumentLinks,
        options: RenderingOptions,
        writer: inout Writer,
    ) {
        let visibleExperience = visibleExperience(experience, options: options)
        guard !visibleExperience.isEmpty else {
            renderEmptySection("## \(labels.experience)", options: options, writer: &writer)
            return
        }

        var lines = ["## \(labels.experience)"]
        for work in visibleExperience {
            lines.append("### \(workHeading(work, links: links))")
            lines.append(format(work.period, isCurrent: work.isCurrent))
            appendFocus(work.technicalFocus, to: &lines)

            if options.nestProjectsUnderRoles {
                appendNestedProjects(work.projects, options: options, to: &lines)
            }
        }

        writer.block(lines)
    }

    /// Renders the standalone `## Projects` section as its own block.
    ///
    /// When `nestProjectsUnderRoles` is true the projects render under each role
    /// in the Experience section, so this section emits nothing. When false it
    /// lists every project as a first-class, policy-ordered section, drawn from
    /// the full experience so the projects are not lost when the Experience
    /// section is filtered (by `recentCompanyCount`/`selectedExperienceIDs`).
    func renderProjects(_ experience: [WorkExperience], options: RenderingOptions, writer: inout Writer) {
        guard !options.nestProjectsUnderRoles else {
            return
        }

        let projects = experience.flatMap(\.projects)
        guard !projects.isEmpty else {
            renderEmptySection("## \(labels.projects)", options: options, writer: &writer)
            return
        }

        var lines = ["## \(labels.projects)"]
        for projectExperience in projects {
            appendProject(projectExperience, headingLevel: "###", options: options, to: &lines)
        }

        writer.block(lines)
    }

    func renderEducation(_ education: [Education], options: RenderingOptions, writer: inout Writer) {
        guard !education.isEmpty else {
            renderEmptySection("## \(labels.education)", options: options, writer: &writer)
            return
        }

        var lines = ["## \(labels.education)"]
        for item in education {
            lines.append("### \(escapedMarkdownText(item.institution))")
            if let degreeFieldLine = degreeFieldLine(degree: item.degree, field: item.field) {
                lines.append(degreeFieldLine)
            }
            lines.append(format(item.period, isCurrent: false))
        }

        writer.block(lines)
    }

    func renderPublicEvidence(_ evidence: [PublicEvidence], options: RenderingOptions, writer: inout Writer) {
        guard !evidence.isEmpty else {
            renderEmptySection("## \(labels.publicEvidence)", options: options, writer: &writer)
            return
        }

        var lines = ["## \(labels.publicEvidence)"]
        for item in evidence {
            // Never emit a bare `### ` heading: when the title and url are both
            // empty, fall back to the evidence kind so the block keeps a heading.
            let headingText = linkedText(item.title, destination: item.url)
            lines.append("### \(headingText.isEmpty ? label(for: item.kind) : headingText)")
            lines.append("\(labels.kind): \(label(for: item.kind))")
            appendLine(labels.role, value: item.role, to: &lines)
            appendEvidenceDate(item, to: &lines)
            appendLine(labels.summary, value: item.summary, to: &lines)
            appendLabelledList(labels.technologies, values: item.technologies, to: &lines)
            appendFocus(item.technicalFocus, to: &lines)
            appendHighlights(item.highlights, to: &lines)
        }

        writer.block(lines)
    }

    func renderSkills(_ skills: [Tech], options: RenderingOptions, writer: inout Writer) {
        guard !skills.isEmpty else {
            renderEmptySection("## \(labels.skills)", options: options, writer: &writer)
            return
        }

        var lines = ["## \(labels.skills)"]
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
            renderEmptySection("## \(labels.links)", options: options, writer: &writer)
            return
        }

        var lines = ["## \(labels.links)"]
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

    func appendProject(
        _ projectExperience: ProjectExperience,
        headingLevel: String,
        options: RenderingOptions,
        to lines: inout [String],
    ) {
        let project = projectExperience.project
        lines.append("\(headingLevel) \(escapedMarkdownText(project.name))")
        lines.append(format(projectExperience.period, isCurrent: project.isCurrent))
        if !projectExperience.role.isPlaceholder {
            appendLine(labels.role, value: projectExperience.role.name, to: &lines)
        }

        for description in limitedDescriptions(project.descriptions, maxCount: options.maxBulletsPerProject) {
            appendParagraph(description, to: &lines)
        }

        // Results-oriented accomplishments render verbatim after the
        // descriptions; the renderer never inflates them or fabricates metrics.
        for accomplishment in project.accomplishments {
            appendParagraph(accomplishment, to: &lines)
        }

        appendLabelledList(labels.technologies, values: project.techs.map(\.name), to: &lines)
        appendFocus(projectExperience.technicalFocus, project.technicalFocus, to: &lines)
        appendProjectLinks(project.urls, to: &lines)
    }

    /// Builds the education `degree in field` line, emitting only the present
    /// side so an empty degree or field never leaks a dangling connector
    /// (`MSc in `, ` in CS`, or ` in `). Returns `nil` when both are empty.
    func degreeFieldLine(degree: String, field: String) -> String? {
        let escapedDegree = escapedMarkdownText(degree)
        let escapedField = escapedMarkdownText(field)

        switch (escapedDegree.isEmpty, escapedField.isEmpty) {
        case (false, false):
            return "\(escapedDegree)\(labels.degreeFieldConnector)\(escapedField)"
        case (false, true):
            return escapedDegree
        case (true, false):
            return escapedField
        case (true, true):
            return nil
        }
    }

    func appendProjectLinks(_ urls: [URL]?, to lines: inout [String]) {
        guard let urls, !urls.isEmpty else {
            return
        }

        let renderedURLs = urls.map { linkedText($0.absoluteString, destination: $0.absoluteString) }
        lines.append("\(labels.projectLinks): \(renderedURLs.joined(separator: ", "))")
    }

    func appendEvidenceDate(_ evidence: PublicEvidence, to lines: inout [String]) {
        if let date = evidence.date?.trimmingCharacters(in: .whitespacesAndNewlines), !date.isEmpty {
            appendLine(labels.date, value: date, to: &lines)
        } else if let period = evidence.period {
            lines.append("\(labels.period): \(format(period, isCurrent: false))")
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
