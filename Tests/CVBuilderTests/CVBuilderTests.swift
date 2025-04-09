import Testing
@testable import CVBuilder

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    func testCreatingCV() {
        let cv = CV.createExampleCV()
        #expect(cv.title == "Senior Mobile Developer")
    }
}
