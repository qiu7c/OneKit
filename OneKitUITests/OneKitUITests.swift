import XCTest

final class OneKitUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // 验证主界面元素存在
        XCTAssertTrue(app.navigationBars["OneKit"].waitForExistence(timeout: 3))
    }

    func testTabNavigation() throws {
        let app = XCUIApplication()
        app.launch()

        // 点击工具 Tab
        app.tabBars.buttons["工具"].tap()

        // 点击设置 Tab
        app.tabBars.buttons["设置"].tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 16.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
