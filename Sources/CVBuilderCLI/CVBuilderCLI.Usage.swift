public extension CVBuilderCLI {
    /// Stable user-facing usage text for the `cvbuilder` executable.
    enum Usage {
        public static let text = """
        Usage: cvbuilder --data <cv.json> --out <output-path> [--format markdown|json] [--check]

        Generate deterministic Markdown or normalized JSON from one CVDocument file.

        Options:
          --data <path>        Input CVDocument JSON file.
          --out <path>         Output file to write or check.
          --format <format>    Output format: markdown or json. Defaults to markdown.
          --check              Compare expected output with --out without writing.
          -h, --help           Show this help text.

        Examples:
          cvbuilder --data cv.json --out cv/index.md
          cvbuilder --data cv.json --out cv/index.md --check
          cvbuilder --data cv.json --out cv.normalized.json --format json
        """
    }
}
