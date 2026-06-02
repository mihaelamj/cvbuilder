import Foundation

extension Rendering.MarkdownDocumentRenderer {
    func workHeading(_ work: WorkExperience, links: DocumentLinks) -> String {
        let company = if let url = companyURL(for: work.company.name, in: links.companyURLs) {
            linkedText(work.company.name, destination: url)
        } else {
            escapedMarkdownText(work.company.name)
        }

        return "\(company) - \(escapedMarkdownText(work.role.name))"
    }

    /// Looks up a company URL by name, preferring an exact key match but falling
    /// back to a whitespace-insensitive match so a key like `"Acme "` still links
    /// the heading `"Acme"`. Returns `nil` when no non-empty URL is found.
    func companyURL(for name: String, in companyURLs: [String: String]) -> String? {
        if let url = companyURLs[name], !url.isEmpty {
            return url
        }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let match = companyURLs
            .filter { !$0.value.isEmpty && $0.key.trimmingCharacters(in: .whitespacesAndNewlines) == trimmedName }
            .min { $0.key < $1.key }

        return match?.value
    }

    func linkedText(_ label: String, destination: String) -> String {
        let escapedLabel = escapedMarkdownText(label)
        guard let encodedDestination = encodedLinkDestination(destination) else {
            return escapedLabel
        }

        // Never emit a blank-label link `[](dest)` / `[ ](dest)`: when the label
        // is empty or whitespace, show the destination itself as the visible
        // text. If even that is blank (e.g. a control-character-only
        // destination), return empty so callers can omit or substitute the link
        // rather than render a blank label.
        let visibleLabel = escapedLabel.isEmpty ? escapedMarkdownText(destination) : escapedLabel
        guard !visibleLabel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return ""
        }

        return "[\(visibleLabel)](\(encodedDestination))"
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

        appendLabelledList(labels.technicalFocus, values: areas, to: &lines)
        appendLabelledList(labels.technicalTags, values: tags, to: &lines)
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
        recentCompanyCount: Int?,
    ) -> [WorkExperience] {
        guard let recentCompanyCount else {
            return experience
        }

        guard recentCompanyCount > 0 else {
            return experience
        }

        return Array(experience.prefix(recentCompanyCount))
    }

    func visibleExperience(
        _ experience: [WorkExperience],
        options: RenderingOptions,
    ) -> [WorkExperience] {
        // Explicit selection is the higher-priority concept: when
        // `selectedExperienceIDs` is non-empty it bounds the rendered set in the
        // curated order, and the recency cap does not further truncate it. The
        // cap only applies when no explicit selection is given.
        guard options.selectedExperienceIDs.isEmpty else {
            return selectedExperience(experience, selectedIDs: options.selectedExperienceIDs)
        }

        return limitedExperience(experience, recentCompanyCount: options.recentCompanyCount)
    }

    func selectedExperience(
        _ experience: [WorkExperience],
        selectedIDs: [UUID],
    ) -> [WorkExperience] {
        guard !selectedIDs.isEmpty else {
            return experience
        }

        var experienceByID: [UUID: WorkExperience] = [:]
        for work in experience {
            guard let id = work.id, experienceByID[id] == nil else {
                continue
            }

            experienceByID[id] = work
        }

        var seenSelectedIDs: Set<UUID> = []
        return selectedIDs.compactMap { selectedID in
            guard seenSelectedIDs.insert(selectedID).inserted else {
                return nil
            }

            return experienceByID[selectedID]
        }
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
        let startText = period.start.map(format)
        let endText = period.end.map(format)

        guard !isCurrent else {
            // Ongoing: "<start> - Present", or just "Present" when the start is
            // unknown.
            guard let startText else {
                return labels.present
            }

            return "\(startText) - \(labels.present)"
        }

        switch (startText, endText) {
        case let (start?, end?):
            // Equal start and end collapse to a single token (e.g. "Jan 2024"),
            // rather than rendering the redundant "Jan 2024 - Jan 2024".
            return period.start == period.end ? start : "\(start) - \(end)"
        case let (start?, nil):
            return start
        case let (nil, end?):
            return end
        case (nil, nil):
            return ""
        }
    }

    func format(_ date: Period.SimpleDate) -> String {
        let monthNames = labels.monthNames

        // Decoding validates `month` to 1...12; this guard stays defensive for
        // in-memory values and falls back to a valid year-only token instead of
        // a malformed "2024-13" ISO string.
        guard (1 ... monthNames.count).contains(date.month) else {
            return "\(date.year)"
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
            nil,
        ]

        return preferredOrder.filter { category in
            skills.contains { $0.category == category }
        }
    }

    func label(for category: Tech.Category?) -> String {
        switch category {
        case .language:
            labels.categoryLanguages
        case .framework:
            labels.categoryFrameworks
        case .tool:
            labels.categoryTools
        case .platform:
            labels.categoryPlatforms
        case .concept:
            labels.categoryConcepts
        case .other:
            labels.categoryOther
        case nil:
            labels.categoryUncategorized
        }
    }

    func label(for kind: PublicEvidenceKind) -> String {
        switch kind {
        case .openSource:
            labels.kindOpenSource
        case .talk:
            labels.kindTalk
        case .publication:
            labels.kindPublication
        case .app:
            labels.kindApp
        case .package:
            labels.kindPackage
        case .technicalWriting:
            labels.kindTechnicalWriting
        case .project:
            labels.kindProject
        case .other:
            labels.kindOther
        }
    }
}
