//
//  ChangeRateTests.swift
//  lebaluchonTests
//
//  Created by Elodie Gage on 04/01/2024.
//

import XCTest
@testable import lebaluchon

final class ChangeRateTests: XCTestCase {
// Mock UserDefaults to simulate saving and retrieving data
    class MockUserDefaults: UserDefaults {
        var changeRateDateValue: String?
        var changeRateValue: Double?
        
        override func string(forKey defaultName: String) -> String? {
            return defaultName == ChangeRateData.Keys.currentChangeRateDate ? changeRateDateValue : nil
        }
        
        override func double(forKey defaultName: String) -> Double {
            return defaultName == ChangeRateData.Keys.currentChangeRate ? changeRateValue ?? 0.0 : 0.0
        }
        
        override func set(_ value: Any?, forKey defaultName: String) {
            if defaultName == ChangeRateData.Keys.currentChangeRateDate {
                changeRateDateValue = value as? String
            } else if defaultName == ChangeRateData.Keys.currentChangeRate {
                changeRateValue = value as? Double
            }
        }
    }
    
    class ChangeRateTests: XCTestCase {
        
        var mockUserDefaults: MockUserDefaults!
        
        override func setUpWithError() throws {
            super.setUp()
            mockUserDefaults = MockUserDefaults()
        }
        
        override func tearDownWithError() throws {
            mockUserDefaults = nil
            super.tearDown()
        }
        
        func testDecodingChangeRate() throws {
            let jsonData = """
        {
            "date": "2023-11-15",
            "rates": {
                "USD": 1.131164
            }
        }
        """.data(using: .utf8)!
            
            let changeRate = try JSONDecoder().decode(ChangeRate.self, from: jsonData)
            XCTAssertEqual(changeRate.date, "2023-11-15")
            XCTAssertEqual(changeRate.rates.USD, 1.131164)
        }
        
        func testChangeRateDateGetSet() {
            let date = "2023-11-15"
            ChangeRateData.changeRateDate = date // Set
            XCTAssertEqual(ChangeRateData.changeRateDate, date) // Get and assert
        }
        
        func testChangeRateGetSet() {
            let rate: Double = 1.131164
            ChangeRateData.changeRate = rate // Set
            XCTAssertEqual(ChangeRateData.changeRate, rate) // Get and assert
        }
        
    }

}
