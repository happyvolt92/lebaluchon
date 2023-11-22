//
//  WeatherTests.swift
//  lebaluchonTests
//
//  Created by Elodie Gage on 17/11/2023.
//
@testable import lebaluchon
import XCTest

class WeatherServiceTestCase: XCTestCase {

    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let weatherService = WeatherServices(session: URLSessionFake(data: nil, response: nil, error: FakeTranslatorResponseData.error))
        // When
        weatherService.fetchWeather(for: "nyc") { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .requestError)
            case .success:
                XCTFail("Request should fail with apiError")
            }
        }
    }

    func testGetWeatherShouldPostFailedCallbackIfNoDataAvailable() {
        // Given
        let weatherService = WeatherServices(session: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        weatherService.fetchWeather(for: "nyc") { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noDataAvailable)
            case .success:
                XCTFail("Request should fail with noDataAvailable")
            }
        }
    }

    func testGetWeatherShouldPostFailedCallbackIfCorrectDataButIncorrectResponse() {
        // Given
        let weatherService = WeatherServices(session: URLSessionFake(data: FakeWeatherResponseData.weatherCorrectData, response: FakeWeatherResponseData.responseKO, error: nil))
        // When
        weatherService.fetchWeather(for: "nyc") { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .parsingFailed)
            case .success:
                XCTFail("Request should fail with httpResponseError")
            }
        }
    }

    func testGetWeatherShouldPostFailedCallbackIfCorrectResponseButIncorrectData() {
        // Given
        let weatherService = WeatherServices(session: URLSessionFake(data: FakeWeatherResponseData.weatherIncorrectData, response: FakeWeatherResponseData.responseOK, error: nil))
        // When
        weatherService.fetchWeather(for: "nyc") { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .parsingFailed)
            case .success:
                XCTFail("Request should fail with parsingFailed")
            }
        }
    }

    func testGetWeatherShouldPostSuccessfulCallbackIfNoErrorAndCorrectResponseAndCorrectData() {
        // Given
        let weatherService = WeatherServices(session: URLSessionFake(data: FakeWeatherResponseData.weatherCorrectData, response: FakeWeatherResponseData.responseOK, error: nil))
        // When
        weatherService.fetchWeather(for: "nyc") { result in
            // Then
            let expectedWeatherId = 803
            let expectedDescription = "nuageux"
            let expectedTemperature = 7.56
            
            switch result {
            case .failure:
                XCTFail("Request should not fail")
                
            case .success(let weatherForecast):
                XCTAssertNotNil(weatherForecast)
                
                // Print weather details
                print("Actual Weather ID: \(weatherForecast.weather.first!.id)")
                print("Actual Weather Description: \(weatherForecast.weather.first!.description)")
                print("Actual Temperature: \(weatherForecast.main.temp)")
                
                // Verify weather details
                XCTAssertEqual(expectedWeatherId, weatherForecast.weather.first!.id)
                XCTAssertEqual(expectedDescription, weatherForecast.weather.first!.description)
                
                // Verify temperature with accuracy
                XCTAssertEqual(expectedTemperature, weatherForecast.main.temp, accuracy: 0.001)
                
            }
        }
    }

}
