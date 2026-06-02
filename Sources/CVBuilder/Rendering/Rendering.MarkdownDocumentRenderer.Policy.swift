extension Rendering.MarkdownDocumentRenderer {
    struct Policy: Equatable {
        let name: String
        let sections: [Section]
    }

    func policy(for mode: RenderingMode) -> Policy {
        switch mode {
        case .experiencedTechnical:
            Policy(
                name: "Experienced technical CV",
                sections: [.contact, .experience, .projects, .publicEvidence, .skills, .education, .links],
            )
        case .earlyCareerTechnical:
            Policy(
                name: "Early-career technical CV",
                sections: [.contact, .education, .publicEvidence, .experience, .projects, .skills, .links],
            )
        case .publicEvidenceHeavyTechnical:
            Policy(
                name: "Public-evidence-heavy technical CV",
                sections: [.contact, .publicEvidence, .experience, .projects, .skills, .education, .links],
            )
        }
    }
}
