//
//  OneWordUITests.swift
//  OneWordUITests
//
//  Created by Songbai Yan on 15/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import XCTest

class OneWordUITests: XCTestCase {
        
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
    
    func testClearButtonExist(){
        let app = XCUIApplication()
        let isClearExists = app.buttons["clear"].exists
        XCTAssertTrue(isClearExists)
    }

    func testTapAboutButtonToOpenAboutController() {
        let app = XCUIApplication()
        app.navigationBars["随记单词"].buttons["about"].tap()
        let isExists = app.navigationBars["关于"].exists
        XCTAssertTrue(isExists)
    }
    
    func testTapTipButtonToOpenGuideController(){
//        let app = XCUIApplication()
//        app.navigationBars["随记单词"].buttons["guide"].tap()
//        let isExists = app.navigationBars["通知中心指南"].exists
//        XCTAssertTrue(isExists)
    }
    
    func testWordExists() {
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        let predicate = NSPredicate(format:"label BEGINSWITH %@", "/")
        let labelElement = elementsQuery.staticTexts.element(matching: predicate)
        XCTAssertTrue(labelElement.exists)
        let count = elementsQuery.staticTexts.count
        XCTAssertTrue(count == 4)
    }
}
