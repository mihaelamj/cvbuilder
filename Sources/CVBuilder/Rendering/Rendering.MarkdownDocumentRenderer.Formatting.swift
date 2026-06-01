import Foundation

extension Rendering.MarkdownDocumentRenderer {
    func workHeading(_ work: WorkExperience, links: DocumentLinks) -> String {
        let company = if let url = links.companyURLs[work.company.name], !url.isEmpty {
            linkedText(work.company.name, destination: url)
        } else {
            escapedMarkdownText(work.company.name)
        }

        return "\(company) - \(escapedMarkdownText(work.role.name))"
    }

    func linkedText(_ label: String, destination: String) -> String {
        let escapedLabel = escapedMarkdownText(label)
        guard let encodedDestination = encodedLinkDestination(destination) else {
            return escapedLabel
        }

        return "[\(escapedLabel)](\(encodedDestination))"
    }

    func appendLine(_ label: String, value: String, to lines: inout [String]) {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            return
        }

        lines.append("\(label): \(escapedMarkdownText(trimmedValue))")
    }

    func appendLinkLine(_ label: String, url: String?, to lines: inout [String]) {
        guard let url else {
            return
        }

        let trimmedURL = url.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedURL.isEmpty else {
            return
        }

        lines.append("\(label): \(linkedText(label, destination: trimmedURL))")
    }

    func appendParagraph(_ value: String, to lines: inout [String]) {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            return
        }

        lines.append(escapedMarkdownText(trimmedValue))
    }

    func appendLabelledList(_ label: String, values: [String], to lines: inout [String]) {
        let visibleValues = values
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !visibleValues.isEmpty else {
            return
        }

        lines.append("\(label): \(visibleValues.map(escapedMarkdownText).joined(separator: ", "))")
    }
}

extension Rendering.MarkdownDocumentRenderer {
    func appendFocus(_ focus: TechnicalFocus?..., to lines: inout [String]) {
        let areas = uniqueValues(focus.flatMap { $0?.areas ?? [] })
        let tags = uniqueValues(focus.flatMap { $0?.tags ?? [] })

        appendLabelledList("Technical focus", values: areas, to: &lines)
        appendLabelledList("Technical tags", values: tags, to: &lines)
    }

    func uniqueValues(_ values: [String]) -> [String] {
        var seen: Set<String> = []
        var result: [String] = []

        for value in values {
            let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedValue.isEmpty, !seen.contains(trimmedValue) else {
                continue
            }

            seen.insert(trimmedValue)
            result.append(trimmedValue)
        }

        return result
    }

    func limitedExperience(
        _ experience: [WorkExperience],
        recentCompanyCount: Int?
    ) -> [WorkExperience] {
        guard let recentCompanyCount else {
            return experience
        }

        guard recentCompanyCount > 0 else {
            return experience
        }

        return Array(experience.prefix(recentCompanyCount))
    }

    func limitedDescriptions(_ descriptions: [String], maxCount: Int?) -> [String] {
        guard let maxCount else {
            return descriptions
        }

        guard maxCount > 0 else {
            return descriptions
        }

        return Array(descriptions.prefix(maxCount))
    }
}

extension Rendering.MarkdownDocumentRenderer {
    func format(_ period: Period, isCurrent: Bool) -> String {
        let start = format(period.start)
        let end = isCurrent ? "Present" : format(period.end)

        return "\(start) - \(end)"
    }

    func format(_ date: Period.SimpleDate) -> String {
        let monthNames = [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec"
        ]

        guard (1 ... monthNames.count).contains(date.month) else {
            return "\(date.year)-\(String(format: "%02d", date.month))"
        }

        return "\(monthNames[date.month - 1]) \(date.year)"
    }

    func orderedSkillCategories(_ skills: [Tech]) -> [Tech.Category?] {
        let preferredOrder: [Tech.Category?] = [
            .language,
            .framework,
            .tool,
            .platform,
            .concept,
            .other,
            nil
        ]

        return preferredOrder.filter { category in
            skills.contains { $0.category == category }
        }
    }

    func label(for category: Tech.Category?) -> String {
        switch category {
        case .language:
            "Languages"
        case .framework:
            "Frameworks"
        case .tool:
            "Tools"
        case .platform:
            "Platforms"
        case .concept:
            "Concepts"
        case .other:
            "Other"
        case nil:
            "Uncategorized"
        }
    }

    func label(for kind: PublicEvidenceKind) -> String {
        switch kind {
        case .openSource:
            "Open source"
        case .talk:
            "Talk"
        case .publication:
            "Publication"
        case .app:
            "App"
        case .package:
            "Package"
        case .technicalWriting:
            "Technical writing"
        case .project:
            "Project"
        case .other:
            "Other"
        }
    }
}
