//
//  ThreeRingTest.swift
//  PhonerciseTests
//
//  Created by Peter Salz on 20.01.18.
//  Copyright © 2018 Peter Salz. All rights reserved.
//

import XCTest
import ThreeRingControl

class ThreeRingTest: XCTestCase
{
    
    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThreeRingView()
    {
        let threeRings = ThreeRingView()
        DispatchQueue.main.async
        {
            threeRings.innerRingValue = 1.0
            threeRings.middleRingValue = 1.0
            threeRings.outerRingValue = 1.0
        }
        
        let _ = expectation(forNotification: NSNotification.Name(rawValue: RingCompletedNotification),
                            object: nil,
                            handler: nil)
        let _ = expectation(forNotification: NSNotification.Name(rawValue: AllRingsCompletedNotification),
                            object: nil,
                            handler: nil)
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
