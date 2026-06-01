import Foundation

public struct StringCVRenderer: CVRendering {
    public var experienceTitle: String {
        "EXPERIENCE"
    }

    public var skillsTitle: String {
        "SKILLS"
    }

    public init() {}

    public func render(cv resume: CV) -> String {
        var output = ""

        output += "Name: \(resume.name)\n"
        output += "Title: \(resume.title)\n\n"
        output += "\(resume.summary)\n\n"

        output += contactSection(from: resume.contactInfo)

        if let edu = resume.education.first {
            output += "\(edu.institution), \(edu.degree) in \(edu.field)\n\n"
        }

        output += "\(experienceTitle)\n\n"
        for exp in resume.experience.sorted(by: { $0.period.end > $1.period.end }) {
            output += "\(exp.company.name) (\(exp.formattedDateRange)) – \(exp.role.name)\n\n"
            for projectExp in exp.projects {
                let project = projectExp.project
                output += "\(project.name)\n"
                for desc in project.descriptions {
                    output += "- \(desc)\n"
                }
                if let urls = project.urls, !urls.isEmpty {
                    for url in urls {
                        output += "- \(url.absoluteString)\n"
                    }
                }
                if !project.techs.isEmpty {
                    let techLine = project.techs.map(\.name).joined(separator: " | ")
                    output += "- | \(techLine) |\n"
                }
                output += "\n"
            }
            output += "\n"
        }

        if !resume.skills.isEmpty {
            output += "### \(skillsTitle)\n"
            let techLine = resume.skills.map(\.name).joined(separator: " | ")
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
            output += "LinkedIn: \(linkedIn.absoluteString)\n"
        }
        if let github = info.github {
            output += "GitHub: \(github.absoluteString)\n"
        }
        if let website = info.website {
            output += "Website: \(website.absoluteString)\n"
        }
        output += "\n"
        return output
    }

    public func save(to url: URL, cv resume: CV) throws {
        let content = render(cv: resume)
        try FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try content.write(to: url, atomically: true, encoding: .utf8)
    }

    public func printToConsole(cv resume: CV) {
        print(render(cv: resume))
    }
}

public struct ConsoleCVRenderer: CVRendering {
    public var experienceTitle: String {
        "EXPERIENCE"
    }

    public var skillsTitle: String {
        "SKILLS"
    }

    public init() {}

    public func render(cv resume: CV) -> String {
        StringCVRenderer().render(cv: resume)
    }

    public func save(to _: URL, cv _: CV) throws {
        // Console renderer doesn't support saving
        throw NSError(
            domain: "ConsoleRenderer",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Cannot save console output."]
        )
    }

    public func printToConsole(cv resume: CV) {
        print(render(cv: resume))
    }
}
