public extension CVBuilderCLI {
    /// Stable user-facing usage text for the `cvbuilder` executable.
    enum Usage {
        public static let text = """
        Usage: cvbuilder --data <cv.json|-> --out <output-path|-> [--format markdown|json] [--check]
               cvbuilder --data <cv.json|-> --validate
               cvbuilder --print-schema
               cvbuilder --init <cv.json> [--force]

        Generate, validate, or scaffold deterministic CVDocument JSON and Markdown.

        Options:
          --data <path|->      Input CVDocument JSON file, or - for stdin.
          --out <path|->       Output file to write or check, or - for stdout.
          --format <format>    Output format: markdown or json. Defaults to markdown.
          --check              Compare expected output with --out without writing.
          --validate           Decode and validate input without writing output.
          --print-schema       Print the canonical CVDocument JSON Schema.
          --init <path>        Write a minimal starter CVDocument JSON file.
          --force              Allow --init to replace an existing file.
          -h, --help           Show this help text.

        Examples:
          cvbuilder --data cv.json --out cv/index.md
          cvbuilder --data cv.json --validate
          cvbuilder --print-schema
          cvbuilder --init cv.json
          cat cv.json | cvbuilder --data - --out -
          cvbuilder --data cv.json --out cv/index.md --check
          cvbuilder --data cv.json --out cv.normalized.json --format json
        """
    }
}
