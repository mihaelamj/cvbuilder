import SwiftUI

@main
struct CVDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var cv: CV?
    @State private var pdfURL: URL?
    @State private var markdownURL: URL?
    @State private var showingPDFPreview = false
    @State private var showingMarkdownPreview = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.crop.square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding()
                
                Text("CV Generator")
                    .font(.largeTitle)
                    .bold()
                
                Text("Create and export professional CVs")
                    .foregroundColor(.secondary)
                
                Divider()
                
                Button(action: {
                    cv = createMihaelasCV()
                }) {
                    Label("Generate Mihaela's CV", systemImage: "doc.badge.plus")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if cv != nil {
                    Button(action: {
                        pdfURL = CV.convertToPDFAndSave(cv!, filename: "MihaelaMihaljevicJakicCV")
                        showingPDFPreview = true
                    }) {
                        Label("Export as PDF", systemImage: "arrow.down.doc.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        markdownURL = CV.convertToMarkdownAndSave(cv!, filename: "MihaelaMihaljevicJakicCV")
                        showingMarkdownPreview = true
                    }) {
                        Label("Export as Markdown", systemImage: "arrow.down.doc")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Spacer()
                
                if cv != nil {
                    Text("CV generated successfully!")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .navigationTitle("CV System Demo")
        }
        .sheet(isPresented: $showingPDFPreview) {
            if let url = pdfURL {
                PDFPreviewView(url: url)
            }
        }
        .sheet(isPresented: $showingMarkdownPreview) {
            if let url = markdownURL {
                MarkdownPreviewView(url: url)
            }
        }
    }
}

// Mock PDFPreviewView - in a real app, you'd use PDFKit
struct PDFPreviewView: View {
    let url: URL
    
    var body: some View {
        VStack {
            Text("PDF Preview")
                .font(.headline)
            
            Text(url.lastPathComponent)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("PDF successfully saved at:")
                .padding(.top)
            
            Text(url.path)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
        .padding()
    }
}

// Mock MarkdownPreviewView - in a real app, you'd render the Markdown
struct MarkdownPreviewView: View {
    let url: URL
    @State private var markdownText = ""
    
    var body: some View {
        VStack {
            Text("Markdown Preview")
                .font(.headline)
            
            Text(url.lastPathComponent)
                .foregroundColor(.secondary)
            
            if !markdownText.isEmpty {
                ScrollView {
                    Text(markdownText)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                Text("Loading Markdown...")
            }
        }
        .padding()
        .onAppear {
            do {
                markdownText = try String(contentsOf: url)
            } catch {
                markdownText = "Error loading Markdown: \(error.localizedDescription)"
            }
        }
    }
}
