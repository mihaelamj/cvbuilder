//
//  File.swift
//  CVBuilder
//
//  Created by Mihaela Mihaljevic Jakic on 10.04.2025..
//
@testable import CVBuilder
import Foundation

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
