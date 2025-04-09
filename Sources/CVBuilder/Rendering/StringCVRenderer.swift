import Foundation

public struct StringCVRenderer: CVRendering {
    public var experienceTitle: String { "EXPERIENCE" }
    public var skillsTitle: String { "SKILLS" }
    
    public init() {}

    public func render(cv: CV) -> String {
        var output = ""

        output += "Name: \(cv.name)\n"
        output += "Title: \(cv.title)\n\n"
        output += "\(cv.summary)\n\n"

        output += contactSection(from: cv.contactInfo)

        if let edu = cv.education.first {
            output += "\(edu.institution), \(edu.degree) in \(edu.field)\n\n"
        }

        output += "\(experienceTitle)\n\n"
        for exp in cv.experience.sorted(by: { $0.period.end > $1.period.end }) {
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
                    let techLine = project.techs.map { $0.name }.joined(separator: " | ")
                    output += "- | \(techLine) |\n"
                }
                output += "\n"
            }
            output += "\n"
        }

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

    public func save(to url: URL, cv: CV) throws {
        let content = render(cv: cv)
        try content.write(to: url, atomically: true, encoding: .utf8)
    }

    public func printToConsole(cv: CV) {
        print(render(cv: cv))
    }
}

// MARK: - ConsoleCVRenderer

import Foundation

public struct ConsoleCVRenderer: CVRendering {
    public var experienceTitle: String { "EXPERIENCE" }
    public var skillsTitle: String { "SKILLS" }
    
    public init() {}

    public func render(cv: CV) -> String {
        return StringCVRenderer().render(cv: cv)
    }

    public func save(to url: URL, cv: CV) throws {
        // Console renderer doesn't support saving
        throw NSError(domain: "ConsoleRenderer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cannot save console output."])
    }

    public func printToConsole(cv: CV) {
        print(render(cv: cv))
    }
}
