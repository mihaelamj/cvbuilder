import SwiftUI

struct CVBuilderView: View {
    @State private var name = ""
    @State private var title = ""
    @State private var summary = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var location = ""
    @State private var linkedIn = ""
    @State private var github = ""
    @State private var website = ""
    
    @State private var educations: [Education] = []
    @State private var projects: [Project] = []
    
    @State private var cvGenerated: CV?
    @State private var pdfURL: URL?
    @State private var markdownURL: URL?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                    TextField("Professional Title", text: $title)
                    TextEditor(text: $summary)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                
                Section(header: Text("Contact Information")) {
                    TextField("Email", text: $email)
                    TextField("Phone", text: $phone)
                    TextField("Location", text: $location)
                    TextField("LinkedIn URL", text: $linkedIn)
                    TextField("GitHub URL", text: $github)
                    TextField("Website URL", text: $website)
                }
                
                Section(header: Text("Education")) {
                    NavigationLink(destination: EducationListView(educations: $educations)) {
                        Text("Manage Education")
                    }
                }
                
                Section(header: Text("Projects & Experience")) {
                    NavigationLink(destination: ProjectListView(projects: $projects)) {
                        Text("Manage Projects")
                    }
                }
                
                Section {
                    Button("Generate CV") {
                        generateCV()
                    }
                    
                    if cvGenerated != nil {
                        Button("Export as PDF") {
                            exportAsPDF()
                        }
                        
                        Button("Export as Markdown") {
                            exportAsMarkdown()
                        }
                    }
                }
            }
            .navigationTitle("CV Builder")
        }
    }
    
    private func generateCV() {
        let contactInfo = ContactInfo(
            email: email,
            phone: phone,
            linkedIn: URL(string: linkedIn),
            github: URL(string: github),
            website: URL(string: website),
            location: location
        )
        
        cvGenerated = CV.create(
            name: name,
            title: title,
            summary: summary,
            contactInfo: contactInfo,
            education: educations,
            projects: projects
        )
    }
    
    private func exportAsPDF() {
        guard let cv = cvGenerated else { return }
        
        let safeName = name.replacingOccurrences(of: " ", with: "")
        pdfURL = CV.convertToPDFAndSave(cv, filename: "\(safeName)CV")
    }
    
    private func exportAsMarkdown() {
        guard let cv = cvGenerated else { return }
        
        let safeName = name.replacingOccurrences(of: " ", with: "")
        markdownURL = CV.convertToMarkdownAndSave(cv, filename: "\(safeName)CV")
    }
}

// Supporting views for education and project management would be included here
