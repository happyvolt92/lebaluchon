import XCTest
@testable import lebaluchon

class CurrencyServiceTests: XCTestCase {

    // MARK: - Properties

    var currencyService: CurrencyService!

    // MARK: - Setup

    override func setUpWithError() throws {
        // Use URLSessionFake for testing
        let urlSessionFake = URLSessionFake(configuration: .default)
        currencyService = CurrencyService.shared
        currencyService.urlSession = urlSessionFake
    }

    // MARK: - Tests

    func testGetCurrencyRateSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Currency conversion successful")
        
        let fakeData = FakeChangeRateResponseData.changeRateCorrectData
        let fakeResponse = FakeChangeRateResponseData.responseOK

        // When
        currencyService.getCurrencyRate(to: "USD", from: "EUR", amount: 100) { result in
            // Then
            switch result {
            case .success(let convertedValue):
                XCTAssertEqual(convertedValue, 1.131164, accuracy: 0.001)
                expectation.fulfill()

            case .failure:
                XCTFail("Should not fail for successful conversion")
            }
        }

        wait(for: [expectation], timeout: 20.0) // Increased timeout value
    }

    func testGetCurrencyRateFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Currency conversion should fail")
        let fakeData = FakeChangeRateResponseData.changeRateIncorrectData
        let fakeResponse = FakeChangeRateResponseData.responseKO

        // When
        currencyService.getCurrencyRate(to: "USD", from: "EUR", amount: 100) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Should fail for incorrect data")

            case .failure(let error):
                XCTAssertTrue(error is FakeChangeRateResponseData.FakeChangeRateError)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 20.0) // Increased timeout value
    }

    // MARK: - Mock URLSession

    class URLSessionFake: URLSession {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        init(configuration: URLSessionConfiguration) {
            // Your initialization logic here
        }

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            let task = URLSessionDataTaskFake(
                data: data,
                urlResponse: response,
                responseError: error,
                completionHandler: completionHandler
            )
            return task
        }

        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            let task = URLSessionDataTaskFake(
                data: data,
                urlResponse: response,
                responseError: error,
                completionHandler: completionHandler
            )
            return task
        }
    }

    class URLSessionDataTaskFake: URLSessionDataTask {
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
}
