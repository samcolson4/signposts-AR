//
//  signposts_again_loginUITests.swift
//  signposts-againUITests
//
//  Created by Victoria Jusko on 18/11/2020.
//

import XCTest

class signposts_again_loginUITests: XCTestCase {

    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
        
    }
    
    
    func testcorrectLogin() {
//        person can log in with correct credentials, then they can also log out
        let app = XCUIApplication()
        app.launch()
        app.textFields["email"].tap()
        let textFields = app.textFields["email"]
        textFields.typeText("vika@test.com")
        let secureTextFields = app.secureTextFields["password"]
        app.secureTextFields["password"].tap()
        secureTextFields.typeText("123456")
        app/*@START_MENU_TOKEN@*/.staticTexts["Log In"]/*[[".buttons[\"Log In\"].staticTexts[\"Log In\"]",".staticTexts[\"Log In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertFalse(app.staticTexts["There is no user record corresponding to this identifier"].exists)
        app.tabBars["Tab Bar"].buttons["person"].tap()
        app.buttons["Signout"].tap()
        XCTAssertFalse(app.staticTexts["Profile"].exists)
    
    }
    
    
    
    func testLoginLogout() {
        let app = XCUIApplication()
        app.launch()
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField.typeText("vika@test.com")
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")
        app/*@START_MENU_TOKEN@*/.staticTexts["Log In"]/*[[".buttons[\"Log In\"].staticTexts[\"Log In\"]",".staticTexts[\"Log In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tabBars["Tab Bar"].buttons["person"].tap()
        app.buttons["Signout"].tap()
        XCTAssertFalse(app.staticTexts["Profile"].exists)
    }
    
    
    

}
