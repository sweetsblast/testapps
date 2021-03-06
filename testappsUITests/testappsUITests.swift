//
//  testappsUITests.swift
//  testappsUITests
//
//  Created by 志村晃央 on 2016/12/03.
//  Copyright © 2016年 志村晃央. All rights reserved.
//

import XCTest

class testappsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        app.otherElements.containing(.staticText, identifier:"Label").children(matching: .button).matching(identifier: "Button").element(boundBy: 0).tap()
        XCTAssertNotNil( app.alerts["その他エラー"],"アラートタイトル不一致")
        XCTAssertNotNil( app.alerts["その他エラー"].buttons["OK"], "OKボタンタイトル不一致")
        XCTAssertNotNil( app.alerts["その他エラー"].buttons["cancel"], "CANCELボタンタイトル不一致")
    }
    
    func testEx2() {
        
        let app = XCUIApplication()
        app.otherElements.containing(.staticText, identifier:"Label").children(matching: .button).matching(identifier: "Button").element(boundBy: 0).tap()
        app.alerts["その他エラー"].buttons["OK"].tap()
        XCTAssertNil(app.alerts, "アラートが消えない")
    }
    
}
