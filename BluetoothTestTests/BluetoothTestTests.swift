//
//  BluetoothTestTests.swift
//  BluetoothTestTests
//
//  Created by Vivek Sudarsan on 9/10/15.
//  Copyright (c) 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import XCTest

@testable import BluetoothTest
//@testable import Firebase

class BluetoothTestTests: XCTestCase {
    
    // Create a reference to a Firebase location
//    let firebaseRef = Firebase(url:"https://fiery-heat-4470.firebaseio.com")
//    let userref = Firebase(url:"https://fiery-heat-4470.firebaseio.com/users")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testExample2() {
        // This is an example of a functional test case.
        XCTAssertEqual(1, 2, "They are equal")
    }
    
//    func testFirebaseLogin() {
//        firebaseRef.authUser("bobtony@example.com", password: "correcthorsebatterystaple",
//            withCompletionBlock: { error, authData in
//                if error != nil {
//                    // There was an error logging in to this account
//                    print("Error logging in! \(error)")
//                } else {
//                    // We are now logged in
//                    let email = authData.providerData["email"]
//                    print("\(authData) logged in with email \(email) and id \(authData.uid)")
//                }
//        })
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
