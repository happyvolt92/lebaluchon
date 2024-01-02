import XCTest
@testable import lebaluchon

class WeatherServiceTestCase: XCTestCase {
    
    class URLSessionMock: URLSession {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        init(data: Data?, response: URLResponse?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
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
    
    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let urlSessionMock = URLSessionMock(data: nil, response: nil, error: FakeTranslatorResponseData.error)
        let weatherService = WeatherServices(session: urlSessionMock)
        
        // When
        let expectation = self.expectation(description: "Weather service should complete")
        
        var capturedResult: Result<WeatherResponse, AppError>?
        weatherService.fetchWeather(for: "nyc") { result in
            capturedResult = result
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled or timeout after a specified interval
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // Then
        switch capturedResult {
        case .failure(let error):
            XCTAssertEqual(error, .requestError)
        case .success:
            XCTFail("Request should fail with apiError")
        default:
            XCTFail("Unexpected result")
        }
        
        
        func testGetWeatherShouldPostSuccessfulCallbackIfNoErrorAndCorrectResponseAndCorrectData() {
            // Given
            let urlSessionMock = URLSessionMock(data: FakeWeatherResponseData.weatherCorrectData, response: FakeWeatherResponseData.responseOK, error: nil)
            let weatherService = WeatherServices(session: urlSessionMock)
            
            // When
            let expectation = self.expectation(description: "Weather service should complete")
            
            var capturedResult: Result<WeatherResponse, AppError>?
            weatherService.fetchWeather(for: "nyc") { result in
                capturedResult = result
                expectation.fulfill()
            }
            
            // Wait for the expectation to be fulfilled or timeout after a specified interval
            waitForExpectations(timeout: 5.0, handler: nil)
            
            // Then
            let expectedWeatherId = 803
            let expectedDescription = "nuageux"
            let expectedTemperature = 7.56
            
            switch capturedResult {
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
                
            default:
                break // Do nothing for other cases
            }
        }
    }
}
