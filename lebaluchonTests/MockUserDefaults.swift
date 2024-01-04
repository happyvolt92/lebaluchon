//
//  MockUserDefaults.swift
//  lebaluchonTests
//
//  Created by Elodie Gage on 04/01/2024.
//

import Foundation

class MockUserDefaults: UserDefaults {
    var mockData = [String: Any]()
    
    override func string(forKey defaultName: String) -> String? {
        return mockData[defaultName] as? String
    }
    
    override func double(forKey defaultName: String) -> Double {
        return mockData[defaultName] as? Double ?? 0
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        mockData[defaultName] = value
    }
}

