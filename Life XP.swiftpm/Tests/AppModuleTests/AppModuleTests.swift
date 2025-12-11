import XCTest
@testable import AppModule

final class AppModuleTests: XCTestCase {
    func testBuildConfigurationIsUsable() {
        #if canImport(SwiftUI)
        // On Apple platforms we only check that the module imports successfully.
        XCTAssertTrue(true)
        #else
        // In Linux CI we expect the placeholder entry point to be callable.
        runLifeXPPlaceholder()
        XCTAssertTrue(true)
        #endif
    }
}
