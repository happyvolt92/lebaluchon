//
//  WeatherViewControllerTest.swift
//  lebaluchonTests
//
//  Created by Elodie Gage on 04/01/2024.
//

import XCTest
@testable import lebaluchon

class WeatherViewControllerTests: XCTestCase {
    var sut: WeatherViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "WeatherViewController") as? WeatherViewController
        sut.loadViewIfNeeded()
    }
    
    func testLoadWeatherDataForTextView() {
        // Given
        let city = "New York"
        
        // Create a mock weather response here
        let weatherResponse = WeatherResponse(
            weather: [WeatherDetails(id: 803, description: "broken clouds", icon: "04d")],
            main: Temperature(temp: 4.74)
        )
        
        // Create a URLSessionFake
        let urlSessionFake = URLSessionFake(data: try? JSONEncoder().encode(weatherResponse), response: nil, error: nil)
        
        // Inject the URLSessionFake into the WeatherService
        let weatherService = WeatherServices(session: urlSessionFake)
        
        // Inject the weatherService into the view controller
        sut.weatherService = weatherService
        
        // Create an expectation for the completion
        let expectation = XCTestExpectation(description: "Load weather data expectation for text view")
        
        // When
        sut.loadWeatherData(for: city, textView: sut.weatherInformationNewYork, iconView: sut.weatherIconNewYork)
        
        // Then
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 3)
        
        // Assertions to verify weather data in the text view
        XCTAssertEqual(sut.weatherInformationNewYork.text, "broken clouds\n4.74°C", "Weather information text should match expected format")
    }
    
    func testLoadWeatherIconForIconView() {
        // Given
        let city = "New York"
        
        // Create a mock weather response here
        let weatherResponse = WeatherResponse(
            weather: [WeatherDetails(id: 803, description: "broken clouds", icon: "04d")],
            main: Temperature(temp: 4.74)
        )
        
        // Create a URLSessionFake
        let urlSessionFake = URLSessionFake(data: try? JSONEncoder().encode(weatherResponse), response: nil, error: nil)
        
        // Inject the URLSessionFake into the WeatherService
        let weatherService = WeatherServices(session: urlSessionFake)
        
        // Inject the weatherService into the view controller
        sut.weatherService = weatherService
        
        // Create an expectation for the completion
        let expectation = XCTestExpectation(description: "Load weather icon expectation for icon view")
        
        // When
        sut.loadWeatherIcon(for: city, iconView: sut.weatherIconNewYork)
        
        // Then
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 3)
        
        // Assertions to verify weather icon
        XCTAssertNotNil(sut.weatherIconNewYork.image, "Weather icon should not be nil")
    }

    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
}
