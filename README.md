# CVBuilder

CVBuilder is a modular Swift package designed to represent and render CV (curriculum vitae) data in a structured, reusable way. It provides clean data models, rendering logic for Markdown and plain text, and optional HTML rendering using [Ignite](https://github.com/twostraws/Ignite).

---

## ✨ Features

- 📄 Strongly typed data model for CVs: education, experience, skills, contact info, etc.
- 🧩 Modular architecture: core types are renderer-agnostic.
- 🖋️ Renderers for:
  - **Markdown** (via `MarkdownCVRenderer`)
  - **Plain text** (via `StringCVRenderer`)
  - **HTML** with [Ignite](https://github.com/twostraws/Ignite) (via `IgniteRenderer` in `CVBuilderIgnite`)
  - **Linux TileDown adapter** (via `CVBuilderTileDown.Renderer` in `CVBuilderTileDown`)
- 🧪 Unit-testable and reusable across platforms.

---

## 🧱 Package Structure

This package includes two main libraries, one command-line executable, and one Linux-only adapter target:

### 1. `CVBuilder` (core)

Contains all model types and basic rendering:

```
CV
├── ContactInfo
├── Education
├── WorkExperience
│   ├── Company
│   ├── Role
│   └── ProjectExperience
│       ├── Project
│       └── Tech
└── Period
```

Renderers in `CVBuilder`:
- `MarkdownCVRenderer`
- `StringCVRenderer`

### 2. `CVBuilderIgnite` (optional)

Provides `IgniteRenderer` for HTML rendering, using the [Ignite](https://github.com/twostraws/Ignite) static site generator.

> 🔥 Note: This target depends on `Ignite` and is **separated** to avoid pulling in C dependencies in projects that don’t need HTML rendering.

### 3. `cvbuilder` (executable)

Generates Markdown or normalized JSON from one `CVDocument` JSON file.

### 4. `CVBuilderTileDown` (Linux only)

Provides `CVBuilderTileDown.Renderer`, which renders `CVDocument` or legacy `CV`
values into Markdown for a TileDown-driven publishing pipeline. It does not
generate PDF output.

---

## 📦 Usage

### Add to your `Package.swift` (using branch until Ignite is tagged):

```swift
.package(url: "https://github.com/mihaelamj/cvbuilder.git", branch: "main")
```

Then add the desired product:

```swift
.product(name: "CVBuilder", package: "cvbuilder"),
.product(name: "CVBuilderIgnite", package: "cvbuilder") // if using Ignite
```

The package also exposes the `cvbuilder` executable product for `swift run cvbuilder`.

On Linux only:

```swift
.product(name: "CVBuilderTileDown", package: "cvbuilder")
```

---

## 🛠 How to Generate a Markdown CV

Use the `cvbuilder` command when your CV data lives in a JSON file:

```sh
swift run cvbuilder --data cv.json --out cv/index.md
```

To write normalized `CVDocument` JSON instead of Markdown:

```sh
swift run cvbuilder --data cv.json --out cv.normalized.json --format json
```

To verify that a checked-in output file is current without writing it:

```sh
swift run cvbuilder --data cv.json --out cv/index.md --check
```

The CLI supports `--format markdown` and `--format json`. It does not generate PDF output, ATS scores, or resume-optimizer content.

You can also generate Markdown through Swift code:

```swift
import CVBuilder

let cv = CV.createExampleCV()
let markdown = MarkdownCVRenderer().render(cv: cv)
print(markdown)
```

Or use the utility method to save it:

```swift
if let markdownFile = CV.convertTMarkdownAndSave(cv) {
    print("Markdown saved to: \(markdownFile)")
}
```

---

## 🧪 Full Test Example

```swift

extension CV {
    static func createExampleCV() -> CV {
        
        // Create contact info
        let contactInfo = ContactInfo(
            email: "jane.doe@example.com",
            phone: "+1 (555) 123-4567",
            linkedIn: URL(string: "https://linkedin.com/in/janedoe"),
            github: URL(string: "https://github.com/janedoe"),
            website: URL(string: "https://janedoe.dev"),
            location: "San Francisco, CA"
        )
        
        // Create education
        let education = Education(
            institution: "Stanford University",
            degree: "B.S.",
            field: "Computer Science",
            period: Period(
                start: .init(month: 9, year: 2010),
                end: .init(month: 6, year: 2014)
            )
        )
        
        // Create companies
        let appleCompany = Company(name: "Apple Inc.")
        let googleCompany = Company(name: "Google")
        
        // Create role types
        let juniorIOS = Role(title: "iOS Developer", seniority: .junior)
        let midAndroid = Role(title: "Android Developer", seniority: .mid)
        let seniorIOS = Role(title: "iOS Developer", seniority: .senior)
        let leadIOS = Role(title: "iOS Developer", seniority: .lead)
        
        // Create tech types
        let swift = Tech(name: "Swift", category: .language)
        let swiftUI = Tech(name: "SwiftUI", category: .framework)
        let kotlin = Tech(name: "Kotlin", category: .language)
        let restAPI = Tech(name: "REST API", category: .concept)

        
        // Create projects using the builder pattern
        let project1 = try! Project.Builder()
            .withName("iOS App Redesign")
            .withCompany(appleCompany)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 3, year: 2020), end: (month: 9, year: 2021))
            .addDescription("Led a team of 5 developers for a complete redesign of a flagship iOS app")
            .addDescription("Implemented SwiftUI components for improved user experience")
            .addDescription("Reduced app size by 30% through code optimization")
            .withTechs([swift, swiftUI])
            .addURL(URL(string: "https://apps.apple.com/example")!)
            .build()
        
        let project2 = try! Project.Builder()
            .withName("Android Integration Project")
            .withCompany(googleCompany)
            .withRole(midAndroid)
            .withPeriod(start: (month: 6, year: 2018), end: (month: 2, year: 2020))
            .addDescription("Developed APIs for cross-platform data sharing")
            .addDescription("Implemented secure authentication protocols")
            .withTechs([kotlin, restAPI])
            .build()
        
        // Create the CV
        return CV.create(
            name: "Jane Doe",
            title: "Senior Mobile Developer",
            summary: "Passionate mobile developer with 5+ years experience building apps for iOS and Android platforms. Expert in Swift, SwiftUI, and cross-platform development.",
            contactInfo: contactInfo,
            education: [education],
            projects: [project1, project2]
        )
    }
}


@Test func testCreatingCV() async throws {
    let cv = CV.createExampleCV()
    print("Created")
    #expect(cv.title == "Senior Mobile Developer")

    let markdown = MarkdownCVRenderer().render(cv: cv)
    print("Markdown Preview:")
    print(markdown)

    if let markdownFile = CV.convertTMarkdownAndSave(cv) {
        print("Markdown saved to: \(markdownFile)")
    }
}
```

---

## 📄 Sample Markdown Output

Below is a real CV generated using `MarkdownCVRenderer`:

```
# Jane Doe
## Senior Mobile Developer

Passionate mobile developer with 5+ years experience building apps for iOS and Android platforms. Expert in Swift, SwiftUI, and cross-platform development.

jane.doe@example.com
+1 (555) 123-4567
San Francisco, CA
[LinkedIn](https://linkedin.com/in/janedoe)
[GitHub](https://github.com/janedoe)
[Website](https://janedoe.dev)

Stanford University, B.S. in Computer Science

## EXPERIENCE

### Apple Inc. (Mar 2020 - Sep 2021) – Senior iOS Developer

#### iOS App Redesign
- Led a team of 5 developers for a complete redesign of a flagship iOS app
- Implemented SwiftUI components for improved user experience
- Reduced app size by 30% through code optimization
- [https://apps.apple.com/example](https://apps.apple.com/example)
- | Swift | SwiftUI |


### Google (Jun 2018 - Feb 2020) – Mid Android Developer

#### Android Integration Project
- Developed APIs for cross-platform data sharing
- Implemented secure authentication protocols
- | Kotlin | REST API |


### SKILLS
- | Kotlin | REST API | Swift | SwiftUI |
```

---

## 📄 License

MIT. See `LICENSE` file for details.

---

## 👩‍💻 Author

Built with ❤️ by [Mihaela Mihaljević](https://github.com/mihaelamj)
