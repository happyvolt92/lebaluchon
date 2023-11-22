//
//  TranslatorFakeResponse.swift
//  lebaluchonTests
//
//  Created by Elodie Gage on 17/11/2023.
//

import Foundation

class FakeTranslatorResponseData {

    // MARK: - Data

    static var translatorCorrectData: Data? {
        let bundle = Bundle(for: FakeTranslatorResponseData.self)
        
        guard let url = bundle.url(forResource: "Translator", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            return nil
        }
        
        return jsonData
    }

    static let translatorIncorrectData = "erreur".data(using: .utf8)!

    // MARK: - Response

    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!


    // MARK: - Error
    
    class FakeTranslatorError: Error {}
    static let error = FakeTranslatorError()
}
