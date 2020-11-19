//
//  Explore.swift
//  signposts-againUITests
//
//  Created by Victoria Jusko on 19/11/2020.
//

import XCTest

class Explore: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginExplore() {
// user can login and upon clicking on explore, can view map with exploration of the signs all over the world
        let app = XCUIApplication()
        app.launch()
        app.textFields["email"].tap()
        let textFields = app.textFields["email"]
        textFields.typeText("vika@test.com")
        let secureTextFields = app.secureTextFields["password"]
        app.secureTextFields["password"].tap()
        secureTextFields.typeText("123456")
        app/*@START_MENU_TOKEN@*/.staticTexts["Log In"]/*[[".buttons[\"Log In\"].staticTexts[\"Log In\"]",".staticTexts[\"Log In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCUIApplication().tabBars["Tab Bar"].buttons["binoculars"].tap()
        XCTAssert(app.navigationBars["Explore"].exists)
        XCTAssertFalse(app.textFields["Profile"].exists)
    
        
    }

    
}
