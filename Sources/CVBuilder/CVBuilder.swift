// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public extension CV {
    /// Generic CV creation function that can be used by anyone
    static func create(
        name: String,
        title: String,
        summary: String,
        contactInfo: ContactInfo,
        education: [Education],
        projects: [Project]
    ) -> CV {
        return CV.createFromProjects(
            name: name,
            title: title,
            summary: summary,
            contactInfo: contactInfo,
            education: education,
            projects: projects
        )
    }
    
    /// Generate PDF from any CV
//    static func convertToPDFAndSave(_ cv: CV, filename: String) -> URL? {
//        let generator = CoreGraphicsCVPDFGenerator(cv: cv)
//
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let outputURL = documentsURL.appendingPathComponent("\(filename).pdf")
//
//        if generator.savePDF(to: outputURL) {
//            print("PDF successfully saved to \(outputURL.path)")
//            return outputURL
//        } else {
//            print("Failed to save PDF")
//            return nil
//        }
//    }
//    
//    /// Generate Markdown from any CV
//    static func convertToMarkdownAndSave(_ cv: CV, filename: String) -> URL? {
//        let generator = MarkdownCVRenderer()
//        
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let outputURL = documentsURL.appendingPathComponent("\(filename).md")
//        
//        do {
//            try generator.save(to: outputURL, cv: cv)
//            print("Markdown successfully saved to \(outputURL.path)")
//            return outputURL
//        } catch {
//            print("Failed to save Markdown: \(error)")
//            return nil
//        }
//    }
}
