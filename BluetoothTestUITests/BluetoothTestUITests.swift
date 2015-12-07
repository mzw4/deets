//
//  BluetoothTestUITests.swift
//  BluetoothTestUITests
//
//  Created by Mike Wang on 12/7/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import XCTest

@testable import BluetoothTest

class BluetoothTestUITests: XCTestCase {
    var app: XCUIApplication!
    
    // Get an instance of the main view controller
//    let viewController: ViewController = ViewController()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUI() {
        let app = XCUIApplication()
        let signInButton = app.buttons["Sign In"]
        signInButton.tap()
        signInButton.tap()
        
        let tablesQuery = app.tables
        let entrepreneursMeetupStaticText = tablesQuery.staticTexts["Entrepreneurs Meetup"]
        let exists = NSPredicate(format: "exists == 1")
        
        expectationForPredicate(exists, evaluatedWithObject: entrepreneursMeetupStaticText, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        
        entrepreneursMeetupStaticText.tap()
        
        let hiltonNetworkingEventStaticText = tablesQuery.staticTexts["Hilton Networking Event"]
        hiltonNetworkingEventStaticText.tap()
        hiltonNetworkingEventStaticText.tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Attendees"].tap()
        app.navigationBars["Event Details"].buttons["Back"].tap()
        app.navigationBars["My Events"].buttons["user"].tap()
        
        let eventsButton = elementsQuery.buttons["Events"]
        eventsButton.tap()
        
        let notesButton = elementsQuery.buttons["Notes"]
        notesButton.tap()
        
        let profileNavigationBar = app.navigationBars["Profile"]
        profileNavigationBar.buttons["Back"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Alerts"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"Arya Stark").buttons["\u{f00d}"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"Tyrion Lannister").buttons["\u{f00d}"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"Daenerys Targaryen").buttons["\u{f00c}"].tap()
        tabBarsQuery.buttons["Contacts"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["Princess of Winterfell"].tap()
        eventsButton.tap()
        notesButton.tap()
        
        let contactsButton = profileNavigationBar.buttons["Contacts"]
        contactsButton.tap()
        collectionViewsQuery.staticTexts["Lord Protector of the Vale, Lord of Harrenhal"].tap()
        contactsButton.tap()
        tabBarsQuery.buttons["Home"].tap()
        
    }
    
}
