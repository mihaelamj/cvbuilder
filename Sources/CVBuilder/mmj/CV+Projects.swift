import Foundation

public extension CV {
    static func createMihaelasProjects() -> [Project] {
        var result = [Project]()
        
        // Create companies
        let undabot = Company(name: "Undabot")
        let token = Company(name: "Token")
        let purch = Company(name: "Purch")
        let masinerija = Company(name: "Masinerija")
        let cherishingStudio = Company(name: "Cherishing Studio")
        let iolap = Company(name: "iOLAP")
        let codeWeaver = Company(name: "Code Weaver")
//        let personal = Company(name: "Personal Projects")
        
        // Create tech skills
        let ai = Tech(name: "Artificial Intelligence", category: .concept)
        let appKit = Tech(name: "AppKit", category: .framework)
        let afNet = Tech(name: "AFNetworking", category: .framework)
        let arkit = Tech(name: "ARKit", category: .framework)
        let autoLayout = Tech(name: "AutoLayout", category: .concept)
        let avFoundation = Tech(name: "AVFoundation", category: .framework)
        let barcodes = Tech(name: "Barcodes & QRCodes", category: .concept)
        let carthage = Tech(name: "Carthage", category: .tool)
        let cocoapods = Tech(name: "CocoaPods", category: .tool)
        let coreText = Tech(name: "CoreText", category: .framework)
        let coreGraphics = Tech(name: "CoreGraphics", category: .framework)
        let coreAnimation = Tech(name: "CoreAnimation", category: .framework)
        let coreData = Tech(name: "CoreData", category: .framework)
        let graphql = Tech(name: "GraphQL", category: .concept)
        let inAppPurchase = Tech(name: "In-App Purchase", category: .concept)
        let macos = Tech(name: "macOS", category: .platform)
        let objc = Tech(name: "Objective-C", category: .language)
        let openapi = Tech(name: "OpenAPI", category: .concept)
        let pushNotifications = Tech(name: "Push Notifications", category: .concept)
        let rest = Tech(name: "REST", category: .concept)
        let swift = Tech(name: "Swift", category: .language)
        let swiftUI = Tech(name: "SwiftUI", category: .framework)
        let structConcurrency = Tech(name: "Structured Concurrency", category: .concept)
        let swiftpm = Tech(name: "Swift Package Manager", category: .tool)
        let uitest = Tech(name: "UI Testing", category: .concept)
        let unittest = Tech(name: "Unit Testing", category: .concept)
        let uiKit = Tech(name: "UIKit", category: .framework)
        let uiInCode = Tech(name: "UI in code", category: .concept)
        let webSocket = Tech(name: "WebSockets", category: .concept)
       
        // Create role types
        let juniorIOS = Role(title: "iOS Developer", seniority: .junior)
        let midIOS = Role(title: "iOS Developer", seniority: .mid)
        let seniorIOS = Role(title: "iOS Developer", seniority: .senior)
        let leadIOS = Role(title: "iOS Developer", seniority: .lead)
        
        let tito = try! Project.Builder()
            .withName("Tito")
            .withCompany(undabot)
            .withRole(juniorIOS)
            .withPeriod(start: (month: 9, year: 2013), end: (month: 12, year: 2013))
            .addDescription("iOS (iPad) book application about the life of Josip Broz Tito")
            .addDescription("Objective-C, CocoaPods")
            .addDescription("Implemented custom UI in code (from design sheets)")
            .addDescription("CoreText custom page layouts")
            .withTechs([objc, uiKit, uiInCode, coreText, coreGraphics, coreAnimation, carthage, inAppPurchase])
            .build()
        result.append(tito)
        
        let wogibtswas = try! Project.Builder()
            .withName("wogibtswas.at")
            .withCompany(undabot)
            .withRole(juniorIOS)
            .withPeriod(start: (month: 12, year: 2013), end: (month: 1, year: 2014))
            .addDescription("wogibtswas.at, Austria’s biggest \"what’s on offer\" portal")
            .addDescription("Objective-C, AFNetworking, REST services, CocoaPods")
            .addDescription("Custom UI design in code")
            .addURL(URL(string:"https://itunes.apple.com/de/app/wogibtswas.at-aktionen-angebote/id771962700")!)
            .addURL(URL(string: "https://www.wogibtswas.at")!)
            .withTechs([objc, uiKit, uiInCode, afNet, autoLayout, rest, carthage])
            .build()
        result.append(wogibtswas)
        
        let bladesoho = try! Project.Builder()
            .withName("Blade Soho App")
            .withCompany(undabot)
            .withRole(juniorIOS)
            .withPeriod(start: (month: 1, year: 2014), end: (month: 4, year: 2014))
            .addDescription("Custom app for one of the leading London hair salons")
            .addDescription("Objective-C, AFNetworking, REST services, CocoaPods")
            .addDescription("Implemented custom UI in code (from design sheets)")
            .addURL(URL(string: "https://www.bladesoho.co.uk")!)
            .withTechs([objc, uiKit, uiInCode, afNet, autoLayout, rest, carthage, unittest])
            .build()
        result.append(bladesoho)
        
        let coachlette = try! Project.Builder()
            .withName("Coachlette App")
            .withCompany(undabot)
            .withRole(juniorIOS)
            .withPeriod(start: (month: 5, year: 2014), end: (month: 6, year: 2014))
            .addDescription("Custom app for personal trainers and coaches")
            .addDescription("Objective-C, AFNetworking, REST services, CocoaPods")
            .addDescription("Implemented custom UI in code")
            .withTechs([objc, uiKit, uiInCode, afNet, autoLayout, rest, carthage, unittest])
            .build()
        result.append(coachlette)
        
        let kindergarten = try! Project.Builder()
            .withName("Kindergarten (Cancelled)")
            .withCompany(token)
            .withRole(midIOS)
            .withPeriod(start: (month: 6, year: 2014), end: (month: 7, year: 2014))
            .addDescription("iOS app for a Croatian company, for managing kindergartens")
            .addDescription("Developed 90% of the app")
            .addDescription("Designed REST APIs and implemented them in the app")
            .addDescription("Implemented custom UI design code")
            .withTechs([objc, uiKit, uiInCode, afNet, autoLayout, rest, carthage, unittest, cocoapods])
            .build()
        result.append(kindergarten)
        
        let whatt = try! Project.Builder()
            .withName("Whatt - social network")
            .withCompany(token)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 7, year: 2014), end: (month: 10, year: 2014))
            .addDescription("iOS app for a social network")
            .addDescription("Developed custom expandable TextView with links and tagging")
            .withTechs([objc, uiKit, uiInCode, afNet, autoLayout, rest, carthage, unittest, coreAnimation, cocoapods])
            .build()
        result.append(whatt)
        
        let christresources = try! Project.Builder()
            .withName("Christian Resources")
            .withCompany(token)
            .withRole(midIOS)
            .withPeriod(start: (month: 11, year: 2014), end: (month: 2, year: 2015))
            .addDescription("Universal iOS app (iPhone and iPad), for a client through oDesk")
            .addDescription("Developed the application (100%)")
            .addDescription("Created design in Sketch and implemented it in the application, with dynamic UI for iPhone 4, iPhone 5, iPhone 6, iPhone 6 Plus, and iPad")
            .addDescription("Used Core Animation, Auto Layout, AFNetworking, remote audio streaming")
            .addDescription("Client changed parts of the UI afterward")
            .addURL(URL(string: "https://itunes.apple.com/us/app/bible-study-tools-christian/id600610494")!)
            .withTechs([objc, uiKit, uiInCode, afNet, autoLayout, rest, carthage, unittest, avFoundation, coreGraphics])
            .build()
        result.append(christresources)
        
        let consumr = try! Project.Builder()
            .withName("Consumr App")
            .withCompany(purch)
            .withRole(midIOS)
            .withPeriod(start: (month: 3, year: 2015), end: (month: 1, year: 2018))
            .addDescription("Adapted existing client application for iOS 8+")
            .addDescription("Performed detailed gap analysis for the application, including iOS frontend and REST API backend differences")
            .addDescription("Implemented custom UI design code (from design sheets)")
            .addDescription("REST API implementation")
            .addDescription("Used Core Animation, Auto Layout, AFNetworking, Push Notifications")
            .addURL(URL(string: "https://x.com/purchxapp")!)
            .withTechs([objc, uiKit, uiInCode, pushNotifications, coreAnimation, rest, unittest, autoLayout, barcodes])
            .build()
        result.append(consumr)
        
        let qrcode = try! Project.Builder()
            .withName("QR Code Reader and Scanner App")
            .withCompany(purch)
            .withRole(midIOS)
            .withPeriod(start: (month: 2, year: 2017), end: (month: 10, year: 2018))
            .addDescription("Objective-C, custom UI in code")
            .addDescription("QR code scanning and creation")
            .addDescription("Added custom sharing and feedback functionality")
            .addURL(URL(string: "https://itunes.apple.com/us/app/qr-code-reader-and-scanner/id388175979")!)
            .withTechs([objc, uiKit, uiInCode, coreAnimation, rest, unittest, autoLayout, barcodes])
            .build()
        result.append(qrcode)
        
        let shopsavvy = try! Project.Builder()
            .withName("Shopsavvy App")
            .withCompany(purch)
            .withRole(midIOS)
            .withPeriod(start: (month: 2, year: 2016), end: (month: 10, year: 2018))
            .addDescription("App for shopping and barcode scanning")
            .addDescription("Developer in Swift, UIKit, Auto Layout")
            .addDescription("Worked on parts of the app including barcode scanning, QR code scanning and creation, and general bug fixing")
            .addURL(URL(string: "https://itunes.apple.com/us/app/shop-savvy-barcode-scanner/id338828953")!)
            .withTechs([swift, uiKit, uiInCode, coreAnimation, rest, unittest, autoLayout, barcodes, rest, unittest, swiftpm])
            .build()
        result.append(shopsavvy)
        
        let birthdayrama = try! Project.Builder()
            .withName("Birthdayrama App")
            .withCompany(masinerija)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 11, year: 2018), end: (month: 1, year: 2019))
            .addDescription("A fun way to share birthday wishes with friends and family")
            .addDescription("Refactored the entire app")
            .addDescription("Created a form factory for the app which uses many screens with input fields")
            .addDescription("Used the latest Auto Layout best practices")
            .addURL(URL(string: "https://www.producthunt.com/products/birthdayrama")!)
            .withTechs([swift, uiKit, uiInCode, coreData, autoLayout])
            .build()
        result.append(birthdayrama)
        
        let huxly = try! Project.Builder()
            .withName("Huxly App")
            .withCompany(masinerija)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 2, year: 2019), end: (month: 5, year: 2019))
            .addDescription("Newsreader reimagined")
            .addDescription("Added many features and new screens to the app")
            .addDescription("Login / Sign up / Forgot password screens (dynamic form screens)")
            .addDescription("Demographics screens (dynamic radio control screens using Core Animation)")
            .addDescription("Home and dynamic filter screens")
            .addDescription("Sharing functionality")
            .withTechs([swift, uiKit, uiInCode, coreData, autoLayout, rest, cocoapods])
            .build()
        result.append(huxly)
        
        let breckWorld = try! Project.Builder()
            .withName("Breck World")
            .withCompany(token)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 6, year: 2019), end: (month: 8, year: 2019))
            .addDescription("Built app from scratch in Swift 4+")
            .addDescription("Built UI in code using UIKit and Auto Layout")
            .addDescription("Implemented networking layer using URLSession")
            .addDescription("ARKit integration")
            .withTechs([swift, uiKit, uiInCode, coreData, autoLayout, rest, arkit])
            .build()
        result.append(breckWorld)
        
        let servicepal = try! Project.Builder()
            .withName("ServicePal")
            .withCompany(token)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 5, year: 2019), end: (month: 6, year: 2019))
            .addDescription("Added custom features using Objective-C, UIKit")
            .addDescription("Dynamic Content Framework Developer – designed and implemented a template-based dynamic content creation system that allowed for real-time content generation and updates without requiring app redeployment")
            .addDescription("Increased development efficiency by 35%")
            .addURL(URL(string: "https://servicepal.com")!)
            .withTechs([objc, uiInCode, uiKit, coreData, rest, unittest])
            .build()
        result.append(servicepal)
        
        let wheelsup = try! Project.Builder()
            .withName("Wheels Up")
            .withCompany(cherishingStudio)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 7, year: 2019), end: (month: 8, year: 2020))
            .addDescription("Modernized and refactored legacy Objective-C codebase to Swift")
            .addDescription("Improved maintainability and fixed bugs")
            .addDescription("Simplified login flow to enhance user experience and reduce authentication friction")
            .addDescription("Developed custom UIKit components to improve app performance and user interface")
            .addURL(URL(string: "https://wheelsup.com")!)
            .addURL(URL(string: "https://itunes.apple.com/us/app/wheels-up/id956615077")!)
            .withTechs([objc, swift, uiKit, uiInCode, pushNotifications, rest, afNet, openapi, unittest])
            .build()
        result.append(wheelsup)
        
        let budtz = try! Project.Builder()
            .withName("Budtz Innovation")
            .withCompany(cherishingStudio)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 9, year: 2020), end: (month: 11, year: 2020))
            .addDescription("Led the refactoring of a legacy iOS app’s UI and networking stack using modern Swift paradigms")
            .addDescription("Reorganized the codebase into scalable, feature-driven modules to improve team velocity and onboarding")
            .withTechs([swift, rest, uiKit, uiInCode])
            .build()
        result.append(budtz)
        
        let birch = try! Project.Builder()
            .withName("Birch Finance")
            .withCompany(cherishingStudio)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 8, year: 2020), end: (month: 10, year: 2022))
            .addDescription("Refactored a large iOS app's UI and networking layer using modern Swift")
            .addDescription("Implemented MVVM architecture with a clean separation of concerns")
            .addDescription("Built a comprehensive networking library with complete test coverage")
            .addDescription("Organized code into feature-based modules")
            .addDescription("Improved code quality through formatting, linting, and testing infrastructure")
            .addURL(URL(string: "https://www.birchfinance.com")!)
            .withTechs([swift, rest, uiKit, coreAnimation, uiInCode, unittest, uitest])
            .build()
        result.append(birch)
        
        let zumiez = try! Project.Builder()
            .withName(" ZUMIEZ Stash App")
            .withCompany(iolap)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 11, year: 2022), end: (month: 6, year: 2024))
            .addDescription("Worked on the Zumiez Stash app as a Senior iOS Engineer")
            .addDescription("Created Swift network client code generator from OpenAPI specs")
            .addDescription("Refactored legacy applications and unit-tested critical components")
            .addDescription("Implemented a custom lightweight GraphQL client without external dependencies, featuring type-safe request handling, efficient query utilities, custom GraphQL schema parsing, and sophisticated error management")
            .addDescription("Designed and implemented a modular filtering system with dynamic UI components, supporting complex data sorting and real-time updates")
            .addURL(URL(string: "https://www.zumiez.com")!)
            .addURL(URL(string: "https://apps.apple.com/app/apple-store/id1163863113?pt=118023521&ct=1m2501_web_header_rbn_v")!)
            .withTechs([swift, rest, openapi, graphql, uiKit, uiInCode, swiftpm, unittest])
            .build()
        result.append(zumiez)
        
        let responsumchat = try! Project.Builder()
            .withName("AI Chat SDK")
            .withCompany(iolap)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 7, year: 2024), end: (month: 11, year: 2024))
            .addDescription("Developed a cross-platform chat SDK for iOS and macOS using Swift and SwiftUI for an AI chatbot")
            .addDescription("Implemented real-time messaging, speech recognition, and UI components with modern architecture patterns")
            .addDescription("Designed using modular architecture with 10+ local packages handling UI styling, message management, socket communication, and speech recognition")
            .addDescription("Built with Combine for reactive programming, protocol-oriented design, and comprehensive testing infrastructure")
            .addDescription("Implemented platform-specific components with shared protocols ensuring consistent behavior")
            .withTechs([webSocket, swift, uiKit, ai, swiftpm, macos, unittest, appKit])
            .build()
        result.append(responsumchat)
        
        let germanProject = try! Project.Builder()
            .withName("Anonymous Big EU Project")
            .withCompany(codeWeaver)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 5, year: 2024), end: (month: 12, year: 2024))
            .addDescription("Refactored client backend OpenAPI specs and built a Swift networking package")
            .addDescription("Reorganized and clarified existing OpenAPI specifications to better reflect backend capabilities and client requirements. Ensured consistency and accuracy across endpoints and models")
            .addDescription("Created a modular Swift package to encapsulate networking logic, designed for clean separation of concerns, testability, and reuse across projects")
            .addDescription("Integrated Swift OpenAPI Generator to automatically generate type-safe API client code from OpenAPI specs, enabling seamless updates and minimizing manual maintenance")
            .addDescription("Streamlined the build process to regenerate client code automatically upon spec changes, aligning with CI/CD pipelines and reducing the risk of contract drift")
            .withTechs([swift, swiftUI, rest, openapi, swiftpm, unittest, uitest, structConcurrency])
            .build()
        result.append(germanProject)
        
        let irobot = try! Project.Builder()
            .withName("iRobot App")
            .withCompany(iolap)
            .withRole(seniorIOS)
            .withPeriod(start: (month: 12, year: 2024), end: (month: 3, year: 2025))
            .addDescription("Objective-C, Swift, SwiftUI, UIKit, C++")
            .addDescription("Added features for the onboarding process")
            .addDescription("Automated localization")
            .withTechs([swift, swiftUI, swiftpm, objc, uiKit, uiInCode, unittest])
            .build()
        result.append(irobot)
        return result
    }
}
