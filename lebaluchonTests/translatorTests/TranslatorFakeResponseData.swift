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
        
        guard let url = bundle.url(forResource: "TranslatorFakeData", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            return nil
        }
        
        return jsonData
    }
    
    static var translatorIncorrectData: Data {
        """
        {"incorrectKey": "incorrectValue"}
        """.data(using: .utf8)!
    }
    
    // MARK: - Response
    static var responseOK: HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "https://translation.googleapis.com")!,
                        statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    static var responseKO: HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "https://translation.googleapis.com")!,
                        statusCode: 500, httpVersion: nil, headerFields: nil)!
    }
    // MARK: - Error
    
    class FakeTranslatorError: Error {}
    static let error = FakeTranslatorError()
}

