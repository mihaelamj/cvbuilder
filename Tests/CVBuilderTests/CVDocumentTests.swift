import Testing
@testable import CVBuilder
import Foundation

@Suite("CVDocument")
struct CVDocumentTests {
    // A minimal document JSON with no UUIDs anywhere.
    let json = """
    {
      "frontMatter": { "slug": "cv" },
      "cv": {
        "name": "Ada", "title": "Programmer", "summary": "S.",
        "contactInfo": { "email": "a@x.com", "phone": "1", "location": "London" },
        "experience": [
          { "company": { "name": "Engine" },
            "role": { "title": "Lead", "seniority": "Lead" },
            "period": { "start": { "month": 1, "year": 1842 }, "end": { "month": 12, "year": 1843 } },
            "projects": [
              { "project": { "name": "Bernoulli", "company": { "name": "Engine" },
                  "role": { "title": "Lead", "seniority": "Lead" },
                  "period": { "start": { "month": 1, "year": 1842 }, "end": { "month": 12, "year": 1843 } },
                  "descriptions": ["First algorithm."], "techs": [ { "name": "Math" } ] },
                "role": { "title": "Lead", "seniority": "Lead" },
                "period": { "start": { "month": 1, "year": 1842 }, "end": { "month": 12, "year": 1843 } } }
            ] }
        ],
        "skills": [ { "name": "Math" } ]
      },
      "speaking": [ { "event": "Society", "date": "1843", "role": "Speaker", "title": "T", "location": "London" } ],
      "openSource": [ { "name": "B", "description": "D", "url": "https://x.com/b", "techs": ["Math"] } ]
    }
    """

    @Test("decodes a document from JSON with no UUIDs and synthesizes ids")
    func decodesWithoutUUIDs() throws {
        let doc = try CVDocument.decode(from: Data(json.utf8))
        #expect(doc.cv.name == "Ada")
        #expect(doc.frontMatter["slug"] == "cv")
        #expect(doc.cv.experience.first?.company.name == "Engine")
        #expect(doc.speaking.first?.event == "Society")
        #expect(doc.openSource.first?.name == "B")
        // ids were synthesized, not required.
        #expect(doc.cv.experience.first?.id != nil)
    }

    @Test("renders the full document, including speaking and open source")
    func rendersFullDocument() throws {
        let doc = try CVDocument.decode(from: Data(json.utf8))
        let markdown = MarkdownDocumentRenderer().render(doc)
        #expect(markdown.contains("---\nslug: cv\n---"))
        #expect(markdown.contains("# Ada"))
        #expect(markdown.contains("## EXPERIENCE"))
        #expect(markdown.contains("## OPEN SOURCE"))
        #expect(markdown.contains("## SPEAKING"))
        #expect(markdown.contains("## SKILLS"))
    }

    @Test("optional sections default to empty when absent")
    func minimalDocument() throws {
        let minimal = """
        { "cv": { "name": "N", "title": "T", "summary": "S",
          "contactInfo": { "email": "e", "phone": "p", "location": "l" } } }
        """
        let doc = try CVDocument.decode(from: Data(minimal.utf8))
        #expect(doc.speaking.isEmpty)
        #expect(doc.openSource.isEmpty)
        #expect(doc.cv.experience.isEmpty)
        #expect(doc.frontMatter.isEmpty)
    }
}
