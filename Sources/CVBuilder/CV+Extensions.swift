import Foundation

public extension CV {
    static  func createExampleCV() -> CV {
        // Create companies
        let appleCompany = Company(name: "Apple Inc.")
        let googleCompany = Company(name: "Google")
        
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
        
        // Create projects using the builder pattern
        let project1 = try! Project.Builder()
            .withName("iOS App Redesign")
            .withCompany(appleCompany)
            .withRole(.seniorIOS)
            .withPeriod(start: (month: 3, year: 2020), end: (month: 9, year: 2021))
            .addDescription("Led a team of 5 developers for a complete redesign of a flagship iOS app")
            .addDescription("Implemented SwiftUI components for improved user experience")
            .addDescription("Reduced app size by 30% through code optimization")
            .withTechs([Tech.swift, Tech.swiftUI, Tech.uiKit])
            .addURL(URL(string: "https://apps.apple.com/example")!)
            .build()
            
        let project2 = try! Project.Builder()
            .withName("Android Integration Project")
            .withCompany(googleCompany)
            .withRole(.midIOS)
            .withPeriod(start: (month: 6, year: 2018), end: (month: 2, year: 2020))
            .addDescription("Developed APIs for cross-platform data sharing")
            .addDescription("Implemented secure authentication protocols")
            .withTechs([Tech(name: "Kotlin"), Tech(name: "REST API")])
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
            .withRole(Role.seniorIOS)  // Using predefined role
            .withPeriod(start: (month: 3, year: 2020), end: (month: 9, year: 2021))
            .addDescription("Led a team of 5 developers for a complete redesign of a flagship iOS app")
            .addDescription("Implemented SwiftUI components for improved user experience")
            .addDescription("Reduced app size by 30% through code optimization")
            .withTechs([Tech.swift, Tech.swiftUI, Tech.uiKit])
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
