import XCTest

#if !canImport(ObjectiveC)
func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PrototyperTests.allTests),
    ]
}
#endif
