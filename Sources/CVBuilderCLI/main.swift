import CVBuilder
import Foundation

// cvbuilder: render a CV page from a single JSON document.
//
//   cvbuilder --data cv.json --out cv/index.md
//   cvbuilder --data cv.json                  # prints Markdown to stdout
//   cvbuilder --data cv.json --format json    # re-emit the normalized document
//   cvbuilder --data cv.json --out cv.md --check   # non-zero if out is stale
//
// One JSON file fully describes a publishable CV; no per-site Swift. See #3.

enum CLIError: Error, CustomStringConvertible {
    case missingData
    case unknownFormat(String)
    case stale(String)

    var description: String {
        switch self {
        case .missingData:
            "usage: cvbuilder --data <cv.json> [--out <path>] [--format markdown|json] [--check]"
        case let .unknownFormat(value):
            "unknown --format `\(value)`. Expected `markdown` or `json`."
        case let .stale(path):
            "\(path) is out of date. Re-run cvbuilder to regenerate it."
        }
    }
}

func optionValue(_ name: String, in args: [String]) -> String? {
    guard let i = args.firstIndex(of: name), i + 1 < args.count else { return nil }
    return args[i + 1]
}

func run() throws {
    let args = Array(CommandLine.arguments.dropFirst())
    guard let dataPath = optionValue("--data", in: args) else { throw CLIError.missingData }
    let outPath = optionValue("--out", in: args)
    let format = optionValue("--format", in: args) ?? "markdown"
    let check = args.contains("--check")

    let document = try CVDocument.decode(from: Data(contentsOf: URL(fileURLWithPath: dataPath)))

    let output: String
    switch format {
    case "markdown", "md":
        output = MarkdownDocumentRenderer().render(document)
    case "json":
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        output = String(decoding: try encoder.encode(document), as: UTF8.self) + "\n"
    default:
        throw CLIError.unknownFormat(format)
    }

    guard let outPath else {
        print(output, terminator: "")
        return
    }
    let outURL = URL(fileURLWithPath: outPath)

    if check {
        let existing = (try? String(contentsOf: outURL, encoding: .utf8)) ?? ""
        guard existing == output else { throw CLIError.stale(outPath) }
        return
    }

    try FileManager.default.createDirectory(
        at: outURL.deletingLastPathComponent(),
        withIntermediateDirectories: true
    )
    try output.write(to: outURL, atomically: true, encoding: .utf8)
    FileHandle.standardError.write(Data("cvbuilder: wrote \(outPath)\n".utf8))
}

do {
    try run()
} catch {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(1)
}
