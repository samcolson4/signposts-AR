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

    func testSignup() {
//        user can sign up to become a member of signposts
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Not a user?"]/*[[".buttons[\"Not a user?\"].staticTexts[\"Not a user?\"]",".staticTexts[\"Not a user?\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textFields["username"].tap()
        let usernamenew = app.textFields["username"]
        usernamenew.typeText("user")

        let emailnew = app.textFields["email"]
        emailnew.tap()
        emailnew.typeText("test@test1.com")
       
       let passwordnew = app.secureTextFields["password"]
        passwordnew.tap()
        passwordnew.typeText("123456")
        app/*@START_MENU_TOKEN@*/.staticTexts["Register"]/*[[".buttons[\"Register\"].staticTexts[\"Register\"]",".staticTexts[\"Register\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tabBars["Tab Bar"].buttons["person"].tap()
        XCTAssertFalse(app.staticTexts["Vikarika"].exists)
        XCTAssert(app.staticTexts["user"].exists)

    }
    
    func testsignUpFails() {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Not a user?"]/*[[".buttons[\"Not a user?\"].staticTexts[\"Not a user?\"]",".staticTexts[\"Not a user?\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textFields["username"].tap()
        let usernamenew1 = app.textFields["username"]
        usernamenew1.typeText("Vika")
        app.textFields["email"].tap()
        let email2 = app.textFields["email"]
        email2.typeText("vika@test.com")
        app.secureTextFields["password"].tap()
        let password2 = app.secureTextFields["password"]
        password2.typeText("123456")
        app/*@START_MENU_TOKEN@*/.staticTexts["Register"]/*[[".buttons[\"Register\"].staticTexts[\"Register\"]",".staticTexts[\"Register\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertFalse(app.staticTexts["Vika"].exists)
        XCTAssert(app.staticTexts["The email address is already in use by another account."].exists)
    }
    
    func testShortPassword() {
//        user cannot sign up with less than a 6 character long password
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Not a user?"]/*[[".buttons[\"Not a user?\"].staticTexts[\"Not a user?\"]",".staticTexts[\"Not a user?\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textFields["username"].tap()
        let usernamenew1 = app.textFields["username"]
        usernamenew1.typeText("Vika")
        app.textFields["email"].tap()
        let email2 = app.textFields["email"]
        email2.typeText("vika@test.com")
        app.secureTextFields["password"].tap()
        let password2 = app.secureTextFields["password"]
        password2.typeText("12")
        app/*@START_MENU_TOKEN@*/.staticTexts["Register"]/*[[".buttons[\"Register\"].staticTexts[\"Register\"]",".staticTexts[\"Register\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertFalse(app.staticTexts["Profile"].exists)
        XCTAssert(app.staticTexts["The password must be 6 characters long or more."].exists)
    }
    

    func testSignUpEmailEmpty() {
                
                
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                
               
            }
        }
    }
}
