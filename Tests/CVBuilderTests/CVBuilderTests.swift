import Testing
@testable import CVBuilder

@Test func testCreatingCV() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let cv = CV.createExampleCV()
    print("Created")
    #expect(cv.title == "Senior Mobile Developer")
}

@Test func testCreatingMihaelasCV() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let mmjCV = CV.createForMihaela()
    print("Created")
    #expect(mmjCV.name == "Mihaela Mihaljević Jakić")
    
    let stringRenderer = StringCVRenderer()
    let stringOutput = stringRenderer.render(cv: mmjCV)
    print("Rendered String Output:\n\n\(stringOutput)")

    let consoleRenderer = ConsoleCVRenderer()
    consoleRenderer.printToConsole(cv: mmjCV)

    #expect(mmjCV.name.isEmpty == false)

    if let markdownFile = CV.convertTMarkdownAndSave(mmjCV) {
        print("Markdown saved to: \(markdownFile)")
    }
    
}
