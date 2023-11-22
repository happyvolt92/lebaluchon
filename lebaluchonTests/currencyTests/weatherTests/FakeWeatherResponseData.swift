//
//  FakeWeatherResponseData.swift
//  lebaluchonTests
//
//  Created by Elodie Gage on 17/11/2023.
//

import Foundation

class FakeWeatherResponseData {

    // MARK: - Data

    static var weatherCorrectData: Data? {
        let bundle = Bundle(for: FakeWeatherResponseData.self)
        let url = bundle.url(forResource: "WeatherFakeData", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static let weatherIncorrectData = "erreur".data(using: .utf8)!

    // MARK: - Response

    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!

    // MARK: - Error

    class FakeWeatherError: Error {}
    static let error = FakeWeatherError()
}
