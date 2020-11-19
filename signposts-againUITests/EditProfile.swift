//
//  EditProfile.swift
//  signposts-againUITests
//
//  Created by Victoria Jusko on 19/11/2020.
//

import XCTest

class EditProfile: XCTestCase {

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

    func testNameChange() throws {
        // person that is already logged in can go and change their name, their name will be updted straight away.
        let app = XCUIApplication()
        app.launch()
        app.tabBars["Tab Bar"].buttons["person"].tap()
        app.buttons["Edit Profile"].tap()
        XCTAssertFalse(app.staticTexts["Vika"].exists)
        XCTAssertFalse(app.staticTexts["Nick"].exists)
        let texfields = app.textFields["enter new username"]
        texfields.tap()
        texfields.typeText("Viktorija")
        app/*@START_MENU_TOKEN@*/.staticTexts["Update Username"]/*[[".buttons[\"Update Username\"].staticTexts[\"Update Username\"]",".staticTexts[\"Update Username\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.staticTexts["Viktorija"].exists)
      
    }
    
    

}
