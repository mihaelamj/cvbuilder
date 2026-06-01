import CVBuilderCLI
import Foundation

@main
struct CVBuilderTool {
    static func main() {
        do {
            let options = try CVBuilderCLI.Options.parse(Array(CommandLine.arguments.dropFirst()))
            let fileSystem = CVBuilderCLI.LocalFileSystem(fileManager: .default)
            try CVBuilderCLI.Runner(fileSystem: fileSystem).run(options)
        } catch let failure as CVBuilderCLI.Failure {
            writeError(failure.message)
            exit(1)
        } catch {
            writeError(String(describing: error))
            exit(1)
        }
    }

    private static func writeError(_ message: String) {
        let data = Data("error: \(message)\n".utf8)
        FileHandle.standardError.write(data)
    }
}
