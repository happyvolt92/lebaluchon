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
    
    
    static let changeRateIncorrectData = "erreur".data(using: .utf8)!

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
