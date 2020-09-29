//
//  PrototyperContinueWithoutLoginTest.swift
//  Prototyper ExampleUITests
//
//  Created by Simon Borowski on 29.09.20.
//

import XCTest

//If this class confirms to XCTestCase, it will show up as executable test
class PrototyperContinueWithoutLoginTest {
    func testViewSwitchAfterLoggingIn() throws {
        //This test checks if the app changes the view after the user continues without login
        let app = XCUIApplication()
        XCUIApplication().launch()
        app.windows.children(matching: .other).element(boundBy: 1).children(matching: .button).element.tap()
        app.sheets.scrollViews.otherElements.buttons["Give feedback"].tap()
        app.navigationBars["Give Feedback"].buttons["Send"].tap()
        app.buttons["Continue with login"].tap()
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.tables.staticTexts["Feedback"].exists)
    }
}
