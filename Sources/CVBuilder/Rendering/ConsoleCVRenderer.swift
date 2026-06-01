import Foundation

public struct ConsoleCVRenderer: CVRendering, Sendable {
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
        // Console renderer writes to stdout and does not support file output.
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
