//
//  signposts_againUITests.swift
//  signposts-againUITests
//
//  Created by Sam Colson on 10/11/2020.
//

import XCTest

class signposts_againUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testloginExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        XCTAssert(app.textFields["email"].exists)
        XCTAssert(app.secureTextFields["password"].exists)
        XCTAssert(app/*@START_MENU_TOKEN@*/.staticTexts["Log In"]/*[[".buttons[\"Log In\"].staticTexts[\"Log In\"]",".staticTexts[\"Log In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssertFalse(app.staticTexts["Profile"].exists)

    }

    func testLoginAttempt() throws {
        let app = XCUIApplication()
        app.launch()
        XCUIApplication()/*@START_MENU_TOKEN@*/.staticTexts["Log In"]/*[[".buttons[\"Log In\"].staticTexts[\"Log In\"]",".staticTexts[\"Log In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.staticTexts["The password is invalid or the user does not have a password."].exists)
//        XCTAssert(app.staticTexts["There is no user record corresponding to this identifier"].exists)
        
    }
    
    func testcorrectLogin() {
        let app = XCUIApplication()
        app.launch()
        app.textFields["email"].tap()
        let textFields = app.textFields["email"]
        textFields.typeText("vikjusko@gmail.com")
        let secureTextFields = app.secureTextFields["password"]
        app.secureTextFields["password"].tap()
        secureTextFields.typeText("5433001Vika")
        app/*@START_MENU_TOKEN@*/.staticTexts["Log In"]/*[[".buttons[\"Log In\"].staticTexts[\"Log In\"]",".staticTexts[\"Log In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertFalse(app.staticTexts["There is no user record corresponding to this identifier"].exists)
    }
    
    func testLoginLogout() {
        
        let app = XCUIApplication()
        app.launch()
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText("vikjusko@gmail.com")
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("5433001Vika")
        app/*@START_MENU_TOKEN@*/.staticTexts["Log In"]/*[[".buttons[\"Log In\"].staticTexts[\"Log In\"]",".staticTexts[\"Log In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tabBars["Tab Bar"].buttons["person"].tap()
        app.buttons["Signout"].tap()
        XCTAssertFalse(app.staticTexts["Profile"].exists)
    }
    
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                
               
            }
        }
    }
}
