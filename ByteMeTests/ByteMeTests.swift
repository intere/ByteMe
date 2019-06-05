//
//  ByteMeTests.swift
//  ByteMeTests
//
//  Created by Eric Internicola on 6/4/19.
//  Copyright © 2019 iColasoft. All rights reserved.
//

import XCTest
@testable import ByteMe

class ByteMeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let animations = Asset.animations(for: .jumpUp, in: .actor)
        XCTAssertNotEqual(0, animations.count)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
