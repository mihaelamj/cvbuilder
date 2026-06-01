import CVBuilderCLI
import Foundation

@main
struct CVBuilderTool {
    static func main() {
        do {
            let command = try CVBuilderCLI.Command.parse(Array(CommandLine.arguments.dropFirst()))
            switch command {
            case .help:
                writeOutput(CVBuilderCLI.Usage.text)
            case let .run(options):
                let fileSystem = CVBuilderCLI.LocalFileSystem(fileManager: .default)
                try CVBuilderCLI.Runner(fileSystem: fileSystem).run(options)
            }
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

    private static func writeOutput(_ message: String) {
        let data = Data("\(message)\n".utf8)
        FileHandle.standardOutput.write(data)
    }
}
