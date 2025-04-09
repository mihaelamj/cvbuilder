import Foundation

public struct MarkdownCVRenderer: CVRendering {
    public var experienceTitle: String { "EXPERIENCE" }
    public var skillsTitle: String { "SKILLS" }
    
    public init() {}

    public func render(cv: CV) -> String {
        var output = ""

        // Header
        output += "# \(cv.name)\n"
        output += "## \(cv.title)\n\n"

        // Summary
        output += "\(cv.summary)\n\n"

        // Contact
        output += contactSection(from: cv.contactInfo)

        // Education
        if let edu = cv.education.first {
            output += "\(edu.institution), \(edu.degree) in \(edu.field)\n\n"
        }

        // Experience
        output += "## \(experienceTitle)\n\n"
        for exp in cv.experience.sorted(by: { $0.period.end > $1.period.end }) {
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
                    let techLine = project.techs.map { $0.name }.joined(separator: " | ")
                    output += "- | \(techLine) |\n"
                }
                output += "\n" // Space between projects
            }
            output += "\n" // Space after each company
        }

        // Skills
        if !cv.skills.isEmpty {
            output += "### \(skillsTitle)\n"
            let techLine = cv.skills.map { $0.name }.joined(separator: " | ")
            output += "- | \(techLine) |\n\n"
        }

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

    public func save(to url: URL, cv: CV) throws {
        let content = render(cv: cv)
        try content.write(to: url, atomically: true, encoding: .utf8)
    }
    
    public func printToConsole(cv: CV) {
        print(render(cv: cv))
    }
}

public extension CV {
    static func convertTMarkdownAndSave(_ cv: CV) -> URL? {
        let generator = MarkdownCVRenderer()
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputURL = documentsURL.appendingPathComponent("CV.md")
        
        do {
            try generator.save(to: outputURL, cv: cv)
            print("Markdown successfully saved to \(outputURL.path)")
            return outputURL
        } catch {
            print("Failed to save Markdown: \(error)")
            return nil
        }
    }
}
