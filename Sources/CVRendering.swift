import Foundation

public protocol CVRendering {
    func render(cv: CV) -> String
    func save(to url: URL, cv: CV) throws
    func printToConsole(cv: CV)
    var experienceTitle: String { get }
    var skillsTitle: String { get }
}
