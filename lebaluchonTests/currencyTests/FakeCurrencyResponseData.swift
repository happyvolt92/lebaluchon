//
//  FakeChangeRateResponseData.swift
//  lebaluchonTests
//
//  Created by Elodie Gage on 17/11/2023.
//

import Foundation

class FakeChangeRateResponseData {

    // MARK: - Data
    
    func changeRateCorrectData()-> Data? {
        let bundle = Bundle(for: FakeChangeRateResponseData.self)
        let url = bundle.url(forResource: "CurrencyFakeRateData", withExtension: "json")!
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error loading JSON data: \(error)")
            return nil
        }
    }
    // Static method to create fake data with an incorrect format
       static func changeRateIncorrectData() -> Data {
           return "InvalidData".data(using: .utf8)!
       }
       
       // Static method to create fake data with a negative exchange rate
       static func changeRateWithNegativeValueData() -> Data {
           let json = "{\"USD\": -1.0}"
           return json.data(using: .utf8)!
       }
       
       // Static method to create fake data with a zero exchange rate
       static func changeRateWithZeroValueData() -> Data {
           let json = "{\"USD\": 0.0}"
           return json.data(using: .utf8)!
       }
       
       // Static method to create fake data with a positive exchange rate
       static func changeRateWithPositiveValueData() -> Data {
           let json = "{\"USD\": 1.5}"
           return json.data(using: .utf8)!
       }
       
       // Static method to create fake data with an exchange rate that exceeds a threshold
       static func changeRateExceedsThresholdData() -> Data {
           let json = "{\"USD\": 100.0}"
           return json.data(using: .utf8)!
       }
    
    // MARK: - Response

    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!

    // MARK: - Error

    class FakeChangeRateError: Error {}
    static let error = FakeChangeRateError()
}
