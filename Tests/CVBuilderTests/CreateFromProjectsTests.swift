@testable import CVBuilder
import Foundation
import Testing

/// Regression coverage for `CV.createFromProjects` data fidelity: current-role
/// ordering (#123) and technical-focus forwarding/aggregation (#124).
@Suite("CV.createFromProjects fidelity")
struct CreateFromProjectsTests {
    @Test("a current company sorts ahead of a finished company with a later end")
    func currentCompanySortsFirst() {
        let current = project(
            company: "Current",
            period: Period(start: .init(month: 1, year: 2020), end: .init(month: 1, year: 2021)),
            isCurrent: true,
        )
        let finished = project(
            company: "Finished",
            period: Period(start: .init(month: 1, year: 2022), end: .init(month: 1, year: 2023)),
            isCurrent: false,
        )

        let cv = CV.create(
            name: "T",
            title: "Engineer",
            summary: "S",
            contactInfo: contactInfo,
            education: [],
            projects: [finished, current],
        )

        #expect(cv.experience.first?.company.name == "Current")
        #expect(cv.experience.first?.isCurrent == true)
    }

    @Test("project technical focus is aggregated onto the company and forwarded to the project experience")
    func technicalFocusIsAggregatedAndForwarded() {
        let first = project(
            company: "Acme",
            technicalFocus: TechnicalFocus(areas: ["Architecture"], tags: ["swift"]),
        )
        let second = project(
            company: "Acme",
            technicalFocus: TechnicalFocus(areas: ["Architecture", "Networking"], tags: ["spm"]),
        )

        let cv = CV.create(
            name: "T",
            title: "Engineer",
            summary: "S",
            contactInfo: contactInfo,
            education: [],
            projects: [first, second],
        )

        let experience = cv.experience.first
        #expect(experience?.technicalFocus?.areas == ["Architecture", "Networking"])
        #expect(experience?.technicalFocus?.tags == ["swift", "spm"])
        #expect(experience?.projects.allSatisfy { $0.technicalFocus != nil } == true)
    }

    @Test("a company with no project focus carries no technical focus")
    func noFocusYieldsNilTechnicalFocus() {
        let cv = CV.create(
            name: "T",
            title: "Engineer",
            summary: "S",
            contactInfo: contactInfo,
            education: [],
            projects: [project(company: "Acme")],
        )

        #expect(cv.experience.first?.technicalFocus == nil)
    }

    private let contactInfo = ContactInfo(email: "a@b.c", phone: "+100000000", location: "Somewhere")

    private func project(
        company: String,
        period: Period = Period(start: .init(month: 1, year: 2020), end: .init(month: 1, year: 2021)),
        isCurrent: Bool = false,
        technicalFocus: TechnicalFocus? = nil,
    ) -> Project {
        Project(
            name: "Project",
            company: Company(name: company),
            descriptions: [],
            techs: [],
            role: Role(title: "Engineer", seniority: .senior),
            period: period,
            isCurrent: isCurrent,
            technicalFocus: technicalFocus,
        )
    }
}
