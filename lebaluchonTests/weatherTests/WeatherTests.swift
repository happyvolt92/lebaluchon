import XCTest
@testable import lebaluchon

// MARK: - Mock URLSession and URLSessionDataTask
class URLSessionMock: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
        super.init()
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskMock(
            data: data,
            urlResponse: response,
            responseError: error,
            completionHandler: completionHandler
        )
        return task
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    init(data: Data?, urlResponse: URLResponse?, responseError: Error?, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
        self.completionHandler = completionHandler
        self.data = data
        self.urlResponse = urlResponse
        self.responseError = responseError
    }
    
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
}

// MARK: - WeatherServiceTestCase
class WeatherServiceTestCase: XCTestCase {
    
    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let urlSessionMock = URLSessionMock(data: nil, response: nil, error: FakeWeatherResponseData.error)
        let weatherService = WeatherServices(session: urlSessionMock)
        
        // When
        let expectation = self.expectation(description: "Weather service should complete with error")
        var capturedResult: Result<WeatherResponse, AppError>?
        weatherService.fetchWeather(for: "nyc") { result in
            capturedResult = result
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 5.0)
        guard case .failure = capturedResult else {
            return XCTFail("Expected failure due to network error, got \(String(describing: capturedResult))")
        }
    }
    
    func testGetWeatherShouldPostSuccessfulCallbackIfNoErrorAndCorrectResponseAndCorrectData() {
        // Given
        let urlSessionMock = URLSessionMock(data: FakeWeatherResponseData.weatherCorrectData, response: FakeWeatherResponseData.responseOK, error: nil)
        let weatherService = WeatherServices(session: urlSessionMock) // Replace with your actual WeatherService

        // When
        let expectation = self.expectation(description: "Weather service should complete successfully")
        var capturedResult: Result<WeatherResponse, AppError>?
        weatherService.fetchWeather(for: "nyc") { result in
            capturedResult = result
            expectation.fulfill()
        }
        // Then
        waitForExpectations(timeout: 5.0)
        guard case .success(let weatherResponse) = capturedResult else {
            return XCTFail("Expected successful response with valid data, got \(String(describing: capturedResult))")
        }
        // Example: Validate first weather detail
        if let firstWeatherDetail = weatherResponse.weather.first {
            XCTAssertEqual(firstWeatherDetail.id, 803, "The weather id should be 803")
            XCTAssertEqual(firstWeatherDetail.description, "nuageux", "The weather description should be 'nuageux'")
        } else {
            XCTFail("Weather details should have at least one entry")
        }
    }
    
    // ... Add additional test methods for timeout, invalid status code, malformed JSON response, etc.
    // For instance, test for timeout error, invalid response status code, or malformed data cases here.
    
    // Test fetching weather times out
    // Test fetching weather times out
    func testGetWeatherShouldPostFailedCallbackIfTimeout() {
        // Given
        let urlSessionMock = URLSessionMock(data: nil, response: nil, error: URLError(.timedOut))
        let weatherService = WeatherServices(session: urlSessionMock)
        
        // When
        let expectation = self.expectation(description: "Weather service should time out")
        var capturedResult: Result<WeatherResponse, AppError>?
        weatherService.fetchWeather(for: "nyc") { result in
            capturedResult = result
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 5.0)
        guard case .failure(let error) = capturedResult else {
            return XCTFail("Expected failure, got \(String(describing: capturedResult))")
        }
        guard case .timeoutError = error else {
            return XCTFail("Expected timeout error, got \(error)")
        }
    }

    
    // Test fetching weather with invalid status code
    func testGetWeatherShouldPostFailedCallbackIfInvalidStatusCode() {
        // Given
        let urlSessionMock = URLSessionMock(data: nil, response: FakeWeatherResponseData.responseKO, error: nil)
        let weatherService = WeatherServices(session: urlSessionMock) // Ensure WeatherServices exists and is accessible
        
        // When
        let expectation = self.expectation(description: "Weather service should report invalid status code")
        var capturedResult: Result<WeatherResponse, AppError>? // Match the error type to AppError
        weatherService.fetchWeather(for: "nyc") { result in
            capturedResult = result
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 5.0)
        guard case .failure = capturedResult else {
            return XCTFail("Expected failure due to invalid status code, got \(String(describing: capturedResult))")
        }
    }
    
    // Test fetching weather with malformed JSON response
    func testGetWeatherShouldPostFailedCallbackIfMalformedJSON() {
        // Given
        let malformedJsonData = "Malformed JSON".data(using: .utf8)!
        let urlSessionMock = URLSessionMock(data: malformedJsonData, response: FakeWeatherResponseData.responseOK, error: nil)
        let weatherService = WeatherServices(session: urlSessionMock)
        
        // When
        let expectation = self.expectation(description: "Weather service should report malformed JSON")
        var capturedResult: Result<WeatherResponse, AppError>? // Match the error type to AppError
        weatherService.fetchWeather(for: "nyc") { result in
            capturedResult = result
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 5.0)
        guard case .failure = capturedResult else {
            return XCTFail("Expected failure due to malformed JSON, got \(String(describing: capturedResult))")
        }
    }
}
