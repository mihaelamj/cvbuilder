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
    let mmProjects = CV.createMihaelasProjects()
    print("Created")
//    #expect(cv.title == "Senior Mobile Developer")
}
