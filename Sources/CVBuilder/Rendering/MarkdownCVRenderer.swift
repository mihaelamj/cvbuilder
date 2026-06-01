import Foundation

public struct MarkdownCVRenderer: CVRendering, Sendable {
    public var experienceTitle: String {
        "EXPERIENCE"
    }

    public var skillsTitle: String {
        "SKILLS"
    }

    public init() {}

    private func renderAttribution() -> String {
        "\n\n---\nCreated with [CVBuilder](https://github.com/mihaelamj/cvbuilder)"
    }

    public func render(cv resume: CV) -> String {
        var output = ""

        // Header
        output += "# \(resume.name)\n"
        output += "## \(resume.title)\n\n"

        // Summary
        output += "\(resume.summary)\n\n"

        // Contact
        output += contactSection(from: resume.contactInfo)

        // Education
        if let edu = resume.education.first {
            output += "\(edu.institution), \(edu.degree) in \(edu.field)\n\n"
        }

        // Experience
        output += "## \(experienceTitle)\n\n"
        for exp in resume.experience.sorted(by: { $0.period.end > $1.period.end }) {
            output += "### \(exp.company.name) (\(exp.formattedDateRange)) – \(exp.role.name)\n\n"
            for projectExp in exp.projects {
                let project = projectExp.project
                output += "#### \(project.name)\n"
                for desc in project.descriptions {
                    output += "- \(desc)\n"
                }
                if let urls = project.urls, !urls.isEmpty {
                    for url in urls {
                        output += "- [\(url.absoluteString)](\(url.absoluteString))\n"
                    }
                }
                if !project.techs.isEmpty {
                    let techLine = project.techs.map(\.name).joined(separator: " | ")
                    output += "- | \(techLine) |\n"
                }
                output += "\n" // Space between projects
            }
            output += "\n" // Space after each company
        }

        // Skills
        if !resume.skills.isEmpty {
            output += "### \(skillsTitle)\n"
            let techLine = resume.skills.map(\.name).joined(separator: " | ")
            output += "- | \(techLine) |\n\n"
        }

        // Attribution
        output += renderAttribution()

        return output
    }

    private func contactSection(from info: ContactInfo) -> String {
        var output = ""
        output += "\(info.email)\n"
        output += "\(info.phone)\n"
        output += "\(info.location)\n"
        if let linkedIn = info.linkedIn {
            output += "[LinkedIn](\(linkedIn.absoluteString))\n"
        }
        if let github = info.github {
            output += "[GitHub](\(github.absoluteString))\n"
        }
        if let website = info.website {
            output += "[Website](\(website.absoluteString))\n"
        }
        output += "\n"
        return output
    }

    public func save(to url: URL, cv resume: CV) throws {
        let content = render(cv: resume)
        try content.write(to: url, atomically: true, encoding: .utf8)
    }

    public func printToConsole(cv resume: CV) {
        print(render(cv: resume))
    }
}

public extension CV {
    static func convertTMarkdownAndSave(_ resume: CV) -> URL? {
        let generator = MarkdownCVRenderer()

        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to save Markdown: documents directory is unavailable.")
            return nil
        }
        let outputURL = documentsURL.appendingPathComponent("CV.md")

        do {
            try generator.save(to: outputURL, cv: resume)
            print("Markdown successfully saved to \(outputURL.path)")
            return outputURL
        } catch {
            print("Failed to save Markdown: \(error)")
            return nil
        }
    }
}
