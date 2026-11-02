import XCTest
import LNPopupCornerTestSupport

final class CornerTests: XCTestCase {
    func testSupportedRadiusPreservesExistingProgressGeometry() throws {
        guard #available(iOS 26.0, *) else { throw XCTSkip("Requires corner API runtime") }
        let result = LNPopupRunCornerFixture(true, true, 0, 7.5)
        XCTAssertEqual(result["radiusCalls"]?.intValue, 1)
        XCTAssertEqual(result["configurationCalls"]?.intValue, 1)
        XCTAssertEqual(result["x"]?.doubleValue, 7.5)
        XCTAssertEqual(result["width"]?.doubleValue, 375)
        XCTAssertEqual(result["bottom"]?.doubleValue, 40)
    }

    func testMissingRadiusUsesCompactLegacyGeometryWithoutCallingSelector() throws {
        guard #available(iOS 26.0, *) else { throw XCTSkip("Requires corner API runtime") }
        let result = LNPopupRunCornerFixture(false, true, 0, 123)
        XCTAssertEqual(result["radiusCalls"]?.intValue, 0)
        XCTAssertEqual(result["x"]?.doubleValue, 0)
        XCTAssertEqual(result["width"]?.doubleValue, 390)
        XCTAssertEqual(result["bottom"]?.doubleValue, 40)
    }

    func testMissingConfigurationDoesNotDisableSupportedRadius() throws {
        guard #available(iOS 26.0, *) else { throw XCTSkip("Requires corner API runtime") }
        let result = LNPopupRunCornerFixture(true, false, 0, 7.5)
        XCTAssertEqual(result["radiusCalls"]?.intValue, 1)
        XCTAssertEqual(result["configurationCalls"]?.intValue, 0)
        XCTAssertEqual(result["x"]?.doubleValue, 7.5)
        XCTAssertEqual(result["width"]?.doubleValue, 375)
        XCTAssertEqual(result["layerRadius"]?.doubleValue, 0)
    }

    func testMissingConfigurationPreservesSquareProgressWithoutCallingSetter() throws {
        guard #available(iOS 26.0, *) else { throw XCTSkip("Requires corner API runtime") }
        let result = LNPopupRunCornerFixture(false, false, 0, 123)
        XCTAssertEqual(result["radiusCalls"]?.intValue, 0)
        XCTAssertEqual(result["configurationCalls"]?.intValue, 0)
        XCTAssertEqual(result["layerRadius"]?.doubleValue, 0)
        XCTAssertEqual(result["width"]?.doubleValue, 390)
    }
}
