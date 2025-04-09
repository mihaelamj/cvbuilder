import Foundation

public extension CV {
    static func createFromProjectsNew(
        name: String,
        title: String,
        summary: String,
        contactInfo: ContactInfo,
        education: [Education],
        projects: [Project]
    ) -> CV {
        // Group by company
        let grouped = Dictionary(grouping: projects) { project in
            return project.company
        }

        // Create WorkExperience entries
        let experiences: [WorkExperience] = grouped.map { company, companyProjects in
            let projectExperiences = companyProjects.map {
                ProjectExperience(project: $0, role: $0.role, period: $0.period)
            }

            let start = projectExperiences.map { $0.period.start }.min()!
            let end = projectExperiences.map { $0.period.end }.max()!
            let period = Period(start: start, end: end)

            // Find the role with highest seniority
            let highestRole = projectExperiences.map(\.role).max { a, b in
                a.seniority < b.seniority
            } ?? projectExperiences.first!.role

            return WorkExperience(
                company: company,
                role: highestRole,
                period: period,
                projects: projectExperiences.sorted { $0.period.start < $1.period.start }
            )
        }
        .sorted { $0.period.end > $1.period.end } // most recent first

        let uniqueSkills = Set(projects.flatMap(\.techs)).sorted { $0.name < $1.name }

        return CV(
            name: name,
            title: title,
            summary: summary,
            contactInfo: contactInfo,
            experience: experiences,
            education: education,
            skills: uniqueSkills
        )
    }
}

public extension CV {
    static func createExampleCVWithFlexibleRoles() -> CV {
        // Create companies
        let appleCompany = Company(name: "Apple Inc.")
        let googleCompany = Company(name: "Google")
        let startupCompany = Company(name: "Innovative Startup")
        
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
        
        // Create projects using the builder pattern with different role types
        let project1 = try! Project.Builder()
            .withName("iOS App Redesign")
            .withCompany(appleCompany)
            .withCustomRole(title: "iOS Engineer", seniority: .lead)
            .withPeriod(start: (month: 3, year: 2020), end: (month: 9, year: 2021))
            .addDescription("Led a team of 5 developers for a complete redesign of a flagship iOS app")
            .addDescription("Implemented SwiftUI components for improved user experience")
            .addDescription("Reduced app size by 30% through code optimization")
            .withTechs([Tech(name: "Kotlin"), Tech(name: "REST API")])
            .addURL(URL(string: "https://apps.apple.com/example")!)
            .build()
            
        let project2 = try! Project.Builder()
            .withName("Android Integration Project")
            .withCompany(googleCompany)
            .withCustomRole(title: "Android Developer", seniority: .mid)  // Custom role
            .withPeriod(start: (month: 6, year: 2018), end: (month: 2, year: 2020))
            .addDescription("Developed APIs for cross-platform data sharing")
            .addDescription("Implemented secure authentication protocols")
            .withTechs([Tech(name: "Kotlin"), Tech(name: "REST API")])
            .build()
        
        let project3 = try! Project.Builder()
            .withName("ML-Powered Mobile App")
            .withCompany(startupCompany)
            .withCustomRole(title: "Machine Learning Engineer", seniority: .lead)  // Specialized role
            .withPeriod(start: (month: 1, year: 2021), end: (month: 4, year: 2022))
            .addDescription("Designed and implemented ML models for computer vision on mobile")
            .addDescription("Optimized TensorFlow Lite models for mobile deployment")
            .addDescription("Reduced inference time by 45% through model quantization")
            .withTechs([
                Tech(name: "TensorFlow", category: .framework),
                Tech(name: "Python", category: .language),
                Tech(name: "Core ML", category: .framework)
            ])
            .build()
        
        // Create the CV
        return CV.create(
            name: "Jane Doe",
            title: "Senior Mobile & ML Engineer",
            summary: "Versatile engineer with expertise in iOS, Android, and machine learning integration for mobile platforms. Passionate about creating efficient, user-friendly applications powered by advanced technologies.",
            contactInfo: contactInfo,
            education: [education],
            projects: [project1, project2, project3]
        )
    }
    
    static func testStuff() {
        let janeDoeCV = createExampleCVWithFlexibleRoles()
//        let pdfURL = CV.convertToPDFAndSave(janeDoeCV, filename: "JaneDoeCV")
//        let markdownURL = CV.convertToMarkdownAndSave(janeDoeCV, filename: "JaneDoeCV")
    }

}


public extension CV {
    
    static func createMihaelasCV() -> CV {
        // Create companies
        let undabot = Company(name: "Undabot")
        let token = Company(name: "Token")
        let purch = Company(name: "Purch")
        let masinerija = Company(name: "Masinerija")
        let cherishingStudio = Company(name: "Cherishing Studio")
        let iolap = Company(name: "iOLAP")
        let codeWeaver = Company(name: "Code Weaver")
        let personal = Company(name: "Personal Projects")
        
        // Create contact info
        let contactInfo = ContactInfo(
            email: "mihaelamj@me.com",
            phone: "+385995491157",
            linkedIn: URL(string: "https://www.linkedin.com/in/mihaelamj"),
            github: URL(string: "https://github.com/mihaelamj"),
            website: URL(string: "https://aleahim.com"),
            location: "Crna Voda 38A, 10000 Zagreb, Croatia"
        )
        
        // Create education
        let education = Education(
            institution: "University of Zagreb, Faculty of Humanities and Social Sciences",
            degree: "M.Sc.",
            field: "Information and Speech Science",
            period: Period(
                start: .init(month: 10, year: 1990),
                end: .init(month: 6, year: 1996)
            )
        )
        
        // Create tech skills
        let swift = Tech(name: "Swift", category: .language)
        let swiftUI = Tech(name: "SwiftUI", category: .framework)
        let objc = Tech(name: "Objective-C", category: .language)
        let uiKit = Tech(name: "UIKit", category: .framework)
        let appKit = Tech(name: "AppKit", category: .framework)
        let uiInCode = Tech(name: "UI in code", category: .concept)
        let cocoapods = Tech(name: "CocoaPods", category: .tool)
        let carthage = Tech(name: "Carthage", category: .tool)
        let swiftpm = Tech(name: "Swift Package Manager", category: .tool)
        let openapi = Tech(name: "OpenAPI", category: .concept)
        let rest = Tech(name: "REST", category: .concept)
        let graphql = Tech(name: "GraphQL", category: .concept)
        let coreText = Tech(name: "CoreText", category: .framework)
        let coreGraphics = Tech(name: "CoreGraphics", category: .framework)
        let coreAnimation = Tech(name: "CoreAnimation", category: .framework)
        let autoLayout = Tech(name: "AutoLayout", category: .concept)
        let structConcurrency = Tech(name: "Structured Concurrency", category: .concept)
        let coreData = Tech(name: "CoreData", category: .framework)
        let avFoundation = Tech(name: "AVFoundation", category: .framework)
        let webSocket = Tech(name: "WebSockets", category: .concept)
        let pushNotifications = Tech(name: "Push Notifications", category: .concept)
        let inAppPurchase = Tech(name: "In-App Purchase", category: .concept)
        let barcodes = Tech(name: "Barcodes & QRCodes", category: .concept)
        let arkit = Tech(name: "ARKit", category: .framework)
        let ai = Tech(name: "Artificial Intelligence", category: .concept)
        let macos = Tech(name: "macOS", category: .platform)
        let uitest = Tech(name: "UI Testing", category: .concept)
        let unittest = Tech(name: "Unit Testing", category: .concept)
        
        // Create role types
        let juniorIOS = Role(title: "iOS Developer", seniority: .junior)
        let midIOS = Role(title: "iOS Developer", seniority: .mid)
        let seniorIOS = Role(title: "iOS Developer", seniority: .senior)
        
        // Create projects using builder pattern
        // Here I'll include a few example projects based on your code structure
        // In practice you would include all your projects
        
        let project1 = try! Project.Builder()
            .withName("Banking Mobile App")
            .withCompany(token)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 6, year: 2022), end: (month: 12, year: 2023))
            .addDescription("Implemented secure OAuth2 login flow for banking application")
            .addDescription("Created modular architecture for feature separation and testing")
            .addDescription("Integrated with backend APIs using OpenAPI specifications")
            .withTechs([swift, swiftUI, uiKit, openapi, rest, coreData, structConcurrency])
            .build()
        
        let project2 = try! Project.Builder()
            .withName("Design System Framework")
            .withCompany(undabot)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 3, year: 2020), end: (month: 5, year: 2022))
            .addDescription("Created a comprehensive design system framework for consistent UI across multiple apps")
            .addDescription("Implemented advanced custom UI components with extensive documentation")
            .addDescription("Built CI/CD pipeline for framework distribution and versioning")
            .withTechs([swift, uiKit, swiftUI, coreAnimation, coreGraphics, autoLayout, swiftpm])
            .build()
        
        let project3 = try! Project.Builder()
            .withName("Media Platform App")
            .withCompany(purch)
            .withRole(midIOS)
            .withPeriod(start: (month: 1, year: 2018), end: (month: 2, year: 2020))
            .addDescription("Developed native iOS application for media content delivery")
            .addDescription("Implemented video playback with custom controls and streaming capabilities")
            .addDescription("Created responsive layouts for various iOS device sizes")
            .withTechs([swift, objc, uiKit, avFoundation, rest, cocoapods])
            .build()
        
        let project4 = try! Project.Builder()
            .withName("Augmented Reality Showcase")
            .withCompany(cherishingStudio)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 6, year: 2017), end: (month: 12, year: 2017))
            .addDescription("Built AR experiences for product visualization")
            .addDescription("Optimized 3D model rendering for mobile devices")
            .addDescription("Implemented gesture recognition for AR object manipulation")
            .withTechs([swift, arkit, coreAnimation, uiKit, coreGraphics])
            .build()
        
        let project5 = try! Project.Builder()
            .withName("Analytics Dashboard")
            .withCompany(iolap)
            .withRole(midIOS)
            .withPeriod(start: (month: 1, year: 2016), end: (month: 5, year: 2017))
            .addDescription("Created data visualization components for business analytics")
            .addDescription("Built real-time data synchronization with WebSockets")
            .addDescription("Implemented custom charts and graphs for financial data")
            .withTechs([swift, objc, uiKit, coreGraphics, coreAnimation, webSocket])
            .build()
        
        let project6 = try! Project.Builder()
            .withName("Code Generation Tool")
            .withCompany(codeWeaver)
            .withRole(juniorIOS)
            .withPeriod(start: (month: 3, year: 2014), end: (month: 12, year: 2015))
            .addDescription("Developed macOS application for Swift code generation")
            .addDescription("Built template system for customizable code output")
            .addDescription("Created user interface for defining code generation rules")
            .withTechs([swift, appKit, macos])
            .build()
        
        let project7 = try! Project.Builder()
            .withName("iOS Learning Platform")
            .withCompany(personal)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 1, year: 2019), end: (month: 4, year: 2025))
            .addDescription("Created educational content for teaching iOS development")
            .addDescription("Built sample applications demonstrating Swift and SwiftUI concepts")
            .addDescription("Developed open source libraries for common iOS patterns")
            .withTechs([swift, swiftUI, uiKit, swiftpm, unittest, uitest])
            .build()
        
        // Create the CV using our generic method
        return CVBuilder.CV.create(
            name: "Mihaela Mihaljević Jakić",
            title: "Senior iOS Architect & Developer",
            summary: """
            Experienced iOS engineer with a deep commitment to modular architecture and elegant code. \
            I specialize in OpenAPI-driven development, building robust, multi-platform Swift applications \
            that scale gracefully. My work is defined by clean structure, extreme attention to testability, \
            and the kind of modularization that makes features easy to extend, reason about, and maintain. \
            I take pride in shipping polished, production-grade software that balances design clarity with \
            engineering precision.
            """,
            contactInfo: contactInfo,
            education: [education],
            projects: [project1, project2, project3, project4, project5, project6, project7]
        )
    }

    // Usage example
//    let mihaelasCV = createMihaelasCV()
//    let pdfURL = CV.convertToPDFAndSave(mihaelasCV, filename: "MihaelaMihaljevicJakicCV")
//    let markdownURL = CV.convertToMarkdownAndSave(mihaelasCV, filename: "MihaelaMihaljevicJakicCV")
//
//    // Print CV details to console for verification
//    CV.printCVDetails(mihaelasCV)
}
