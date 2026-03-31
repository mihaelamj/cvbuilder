//
//  CV+Example.swift
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
            email: "mihaelamj@me.com",
            phone: "+385995491157",
            linkedIn: URL(string: "https://www.linkedin.com/in/mihaelamj"),
            github: URL(string: "https://github.com/mihaelamj"),
            website: URL(string: "https://aleahim.com"),
            location: "Zagreb, Croatia"
        )

        // Create education
        let education = Education(
            institution: "University of Zagreb, Faculty of Humanities and Social Sciences",
            degree: "M.Sc.",
            field: "Information and Speech Science",
            period: Period(
                start: .init(month: 10, year: 2005),
                end: .init(month: 6, year: 2010)
            )
        )

        // Create companies
        let maurerElectronics = Company(name: "Maurer Electronics")
        let codeWeaver = Company(name: "Code Weaver")
        let iolap = Company(name: "iOLAP")
        let independent = Company(name: "Independent")

        // Create roles
        let seniorIOSArchitect = Role(title: "iOS Architect", seniority: .senior)
        let seniorIOS = Role(title: "iOS Developer", seniority: .senior)

        // Create techs
        let swift = Tech(name: "Swift", category: .language)
        let swiftUI = Tech(name: "SwiftUI", category: .framework)
        let uiKit = Tech(name: "UIKit", category: .framework)
        let appKit = Tech(name: "AppKit", category: .framework)
        let spm = Tech(name: "Swift Package Manager", category: .tool)
        let openAPI = Tech(name: "OpenAPI", category: .concept)
        let rest = Tech(name: "REST", category: .concept)
        let graphQL = Tech(name: "GraphQL", category: .concept)
        let sse = Tech(name: "SSE", category: .concept)
        let structuredConcurrency = Tech(name: "Structured Concurrency", category: .concept)
        let unitTesting = Tech(name: "Unit Testing", category: .concept)
        let uiTesting = Tech(name: "UI Testing", category: .concept)
        let swiftServer = Tech(name: "Swift Server", category: .framework)
        let webSockets = Tech(name: "WebSockets", category: .concept)
        let ai = Tech(name: "AI", category: .concept)
        let aiTooling = Tech(name: "AI Tooling", category: .concept)
        let mcp = Tech(name: "MCP", category: .concept)

        // Maurer Electronics - ID Document Systems
        let maurerProject = try! Project.Builder()
            .withName("ID Document Systems")
            .withCompany(maurerElectronics)
            .withRole(seniorIOSArchitect)
            .withPeriod(start: (month: 9, year: 2025), end: (month: 3, year: 2026))
            .addDescription("Architecting and developing iOS applications for secure ID document capture, personalisation, and verification")
            .addDescription("Building mobile solutions for Bundesdruckerei GmbH's identity systems platform")
            .addDescription("Designing modular, scalable architectures for security-critical mobile applications")
            .withTechs([swift, swiftUI, uiKit, spm, structuredConcurrency, unitTesting])
            .build()

        // Code Weaver - Anonymous Big EU Project
        let codeWeaverEU = try! Project.Builder()
            .withName("Anonymous Big EU Project")
            .withCompany(codeWeaver)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 5, year: 2024), end: (month: 6, year: 2025))
            .addDescription("Refactored client backend OpenAPI specs and built a Swift networking package")
            .addDescription("Integrated Swift OpenAPI Generator to automatically generate type-safe API client code")
            .addDescription("Streamlined the build process to regenerate client code automatically upon spec changes")
            .withTechs([swift, swiftUI, rest, openAPI, spm, swiftServer, unitTesting, uiTesting, structuredConcurrency])
            .build()

        // Code Weaver - Everliv AI Fitness Chat
        let everlivChat = try! Project.Builder()
            .withName("Everliv AI Fitness Chat")
            .withCompany(codeWeaver)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 5, year: 2024), end: (month: 6, year: 2025))
            .addDescription("Developed cross-platform SwiftUI chat clients for macOS and iOS with real-time messaging")
            .addDescription("Engineered a custom SSE client with fine-grained streaming management and async/await handling")
            .addDescription("Built mock Swift Vapor server implementation with REST API and SSE streaming capabilities")
            .withTechs([swift, swiftUI, rest, openAPI, spm, unitTesting, structuredConcurrency, sse, swiftServer])
            .build()

        // iOLAP - ZUMIEZ Stash App
        let zumiezApp = try! Project.Builder()
            .withName("ZUMIEZ Stash App")
            .withCompany(iolap)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 11, year: 2022), end: (month: 3, year: 2025))
            .addDescription("Created Swift network client code generator from OpenAPI specs")
            .addDescription("Implemented a custom lightweight GraphQL client without external dependencies")
            .addDescription("Designed and implemented a modular filtering system with dynamic UI components")
            .withTechs([swift, rest, openAPI, graphQL, uiKit, spm, unitTesting])
            .addURL(URL(string: "https://www.zumiez.com")!)
            .addURL(URL(string: "https://apps.apple.com/app/apple-store/id1163863113")!)
            .build()

        // iOLAP - AI Chat SDK
        let aiChatSDK = try! Project.Builder()
            .withName("AI Chat SDK")
            .withCompany(iolap)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 11, year: 2022), end: (month: 3, year: 2025))
            .addDescription("Developed a cross-platform chat SDK for iOS and macOS using Swift and SwiftUI for an AI chatbot")
            .addDescription("Designed using modular architecture with 10+ local packages")
            .addDescription("Implemented platform-specific components with shared protocols ensuring consistent behavior")
            .withTechs([swift, swiftUI, uiKit, appKit, webSockets, spm, unitTesting, ai])
            .build()

        // Independent - Cupertino
        let cupertinoProject = try! Project.Builder()
            .withName("Cupertino")
            .withCompany(independent)
            .withRole(seniorIOSArchitect)
            .withPeriod(start: (month: 11, year: 2025), end: (month: 3, year: 2026))
            .addDescription("A local Apple Documentation crawler and MCP server, written in Swift")
            .addDescription("CLI tool providing offline access to Apple developer documentation for AI assistants")
            .withTechs([swift, spm, mcp, aiTooling])
            .addURL(URL(string: "https://github.com/mihaelamj/cupertino")!)
            .build()

        // Independent - iRelay
        let iRelayProject = try! Project.Builder()
            .withName("iRelay")
            .withCompany(independent)
            .withRole(seniorIOSArchitect)
            .withPeriod(start: (month: 3, year: 2026), end: (month: 3, year: 2026))
            .addDescription("Apple-native personal AI assistant, pure Swift")
            .addDescription("Cross-platform macOS and iOS application")
            .withTechs([swift, swiftUI, appKit, ai, aiTooling])
            .addURL(URL(string: "https://github.com/mihaelamj/iRelay")!)
            .build()

        // Create the CV
        return CV.create(
            name: "Mihaela Mihaljević Jakić",
            title: "Senior iOS Architect | Swift Server & OpenAPI | AI Tooling",
            summary: "Experienced iOS engineer with a deep commitment to modular architecture and elegant code. I specialize in OpenAPI-driven development and AI-augmented tooling, building robust, multi-platform Swift applications that scale gracefully. From MCP servers that bring Apple documentation to AI assistants, to native AI-powered apps, I bridge the gap between Apple platform engineering and modern AI workflows.",
            contactInfo: contactInfo,
            education: [education],
            projects: [maurerProject, codeWeaverEU, everlivChat, zumiezApp, aiChatSDK, cupertinoProject, iRelayProject]
        )
    }
}
