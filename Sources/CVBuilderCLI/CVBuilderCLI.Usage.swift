public extension CVBuilderCLI {
    /// Stable user-facing usage text for the `cvbuilder` executable.
    enum Usage {
        public static let text = """
        Usage: cvbuilder --data <cv.json|-> --out <output-path|-> [--from cv-document|json-resume] [--format markdown|json|json-resume] [--front-matter-profile <profile>] [--check]
               cvbuilder --data <cv.json|-> [--from cv-document|json-resume] --validate
               cvbuilder --print-schema
               cvbuilder --init <cv.json> [--force]

        Generate, validate, or scaffold deterministic CVDocument JSON and Markdown.

        Options:
          --data <path|->      Input document file, or - for stdin.
          --out <path|->       Output file to write or check, or - for stdout.
          --from <format>      Input format: cv-document or json-resume. Defaults to cv-document.
          --format <format>    Output format: markdown, json, or json-resume. Defaults to markdown.
          --front-matter-profile <profile>
                              Front matter profile: generic, toucan, hugo, or jekyll.
          --check              Compare expected output with --out without writing.
          --validate           Decode and validate input (honoring --from) without writing output.
          --print-schema       Print the canonical CVDocument JSON Schema.
          --init <path>        Write a minimal starter CVDocument JSON file.
          --force              Allow --init to replace an existing file.
          -h, --help           Show this help text.

        Examples:
          cvbuilder --data cv.json --out cv/index.md
          cvbuilder --data cv.json --validate
          cvbuilder --print-schema
          cvbuilder --init cv.json
          cvbuilder --data cv.json --out cv/index.md --front-matter-profile hugo
          cat cv.json | cvbuilder --data - --out -
          cvbuilder --data cv.json --out cv/index.md --check
          cvbuilder --data cv.json --out cv.normalized.json --format json
          cvbuilder --data resume.json --from json-resume --out cv/index.md
          cvbuilder --data cv.json --out resume.json --format json-resume
        """
    }
}
