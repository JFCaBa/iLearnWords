//
//  iLearnWordsUITests.swift
//  iLearnWordsUITests
//
//  Created by Jose Francisco Catalá Barba on 06/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import XCTest
@testable import iLearnWords

class iLearnWordsUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testASelectLanguageA() {
        app.launch()
        // Goto Settings
        app.buttons["Settings"].tap()
        
        // Tap on Language Option
        var cell = app.tables.cells.element(boundBy: 3)
        XCTAssertTrue(cell.exists)
        cell.tap()
        
        // Select ru-en language
        cell = app.tables.cells.element(boundBy: 5)
        XCTAssertTrue(cell.exists)
        cell.tap()
        
        // Back to the main screen
        app.buttons["Settings"].tap()
        app.buttons["History Words"].tap()
    }
    
    func testBAddWord() {
        app.launch()
        // Paste one word
        UIPasteboard.general.string = "нет"
        app.buttons["Paste"].tap()
        
        // Enter the title for the history and Save
        let txt = app.textFields["Enter a Name"]
        let existsTxt = txt.waitForExistence(timeout: 5)
        XCTAssertTrue(existsTxt)
        txt.typeText("test UI")
        app.buttons["Save"].tap()
        
        // Check the table was updated
        let cell = app.tables.cells.element(boundBy: 0)
        let cellExists = cell.waitForExistence(timeout: 5)
        XCTAssertTrue(cellExists)
        
        // Tap on cell to play sound
        cell.tap()
        sleep(5)
    }

    func testCDeleteHistory() {
        app.launch()
        // Goto Settings again
        app.buttons["Settings"].tap()
        
        // Tap on histories row
        var cell = app.tables.cells.element(boundBy: 4)
        XCTAssertTrue(cell.exists)
        cell.tap()
        
        // Delete the last history (the one we added to test)
        cell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.exists)
        cell.swipeLeft()
        app.buttons["Delete"].tap()
    }
}
