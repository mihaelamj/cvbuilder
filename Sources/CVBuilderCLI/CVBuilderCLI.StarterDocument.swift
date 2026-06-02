import Foundation

public extension CVBuilderCLI {
    /// Starter `CVDocument` JSON used by `cvbuilder --init`.
    enum StarterDocument {
        public static let json = """
        {
          "frontMatter": {
            "slug": "demo-cv",
            "title": "Demo CV"
          },
          "cv": {
            "name": "Demo Candidate",
            "title": "Senior Swift Engineer",
            "summary": "Builds typed Swift tooling for document workflows.",
            "contactInfo": {
              "email": "demo.candidate@example.com",
              "phone": "+1 555 010 0701",
              "location": "Example City"
            },
            "skills": [
              { "name": "Swift", "category": "language" },
              { "name": "Linux", "category": "platform" }
            ]
          }
        }
        """

        public static var data: Data {
            Data("\(json)\n".utf8)
        }
    }
}
