////
//// CurrencyTest.swift
////
//// created by Elodie GAGE on 22/12/23
////
//
//import XCTest
//@testable import lebaluchon
//
//class ChangeRateServiceTests: XCTestCase {
//
//    var sut: ChangeRateService!
//    var mockSession: URLSessionFake!
//
//    override func setUpWithError() throws {
//        super.setUp()
//        mockSession = URLSessionFake(data: nil, response: nil, error: nil)
//        sut = ChangeRateService(session: mockSession) // Ensure ChangeRateService can be initialized with a session
//    }
//
//    override func tearDownWithError() throws {
//        sut = nil
//        mockSession = nil
//        super.tearDown()
//    }
//
//    // Test fetching exchange rate successfully
//    func testFetchExchangeRateSuccess() {
//        // Given
//        let data = MockData.successfulExchangeRateData()
//        let response = HTTPURLResponse(url: URL(string: "https://yourapi.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
//        mockSession.data = data
//        mockSession.response = response
//        mockSession.error = nil
//
//        let expectation = self.expectation(description: "Successful fetch of exchange rate")
//
//        // When
//        sut.getChangeRate { result in
//            switch result {
//                case .success(let rate):
//                    // Then
//                    XCTAssertNotNil(rate)
//                    expectation.fulfill()
//                case .failure:
//                    XCTFail("Expected success, got \(result) instead")
//            }
//        }
//
//        waitForExpectations(timeout: 5)
//    }
//
//    // Test handling network error on fetching exchange rates
//    func testFetchExchangeRateWithNetworkError() {
//        // Given
//        mockSession.error = MockError.networkError
//
//        let expectation = self.expectation(description: "Network error while fetching exchange rate")
//
//        // When
//        sut.getChangeRate { result in
//            if case .failure(let error) = result {
//                // Then
//                XCTAssertNotNil(error)
//                expectation.fulfill()
//            } else {
//                XCTFail("Expected failure, got \(result) instead")
//            }
//        }
//
//        waitForExpectations(timeout: 5)
//    }
//
//    func testInvalidExchangeRateData() {
//        // Given
//        let data = MockData.invalidExchangeRateData()
//        
//        // When
//        let exchangeRate = try? JSONDecoder().decode(ExchangeRate.self, from: data)
//        
//        // Then
//        XCTAssertNil(exchangeRate, "Exchange rate should be nil for invalid data")
//    }
//    
//    func testInvalidConversionAmount() {
////        GIVEN
//        let exchangeRate = ChangeRate(base: "EUR", rate: "USD": 1.2)
//        let amount = -100.0
//        let fromCurrency = "EUR"
//        let toCurrency = "USD"
//        
//        // When
//        let convertedAmount = CurrencyConverter.convert(amount: amount, fromCurrency: fromCurrency, toCurrency: toCurrency, exchangeRate: exchangeRate)
//        
//        // Then
//        XCTAssertEqual(convertedAmount, 0.0, accuracy: 0.01, "Converted amount should be 0.0 for invalid amount")
//    }
//        
//        
//    func testInvalidCurrencyCode() {
//        // Given
//        let exchangeRate = ChangeRate(base: "EUR", rate: "USD": 1.2)
//        let amount = 100.0
//        let fromCurrency = "USD"
//        let toCurrency = "XYZ"
//        
//        // When
//        let convertedAmount = CurrencyConverter.convert(amount: amount, fromCurrency: fromCurrency, toCurrency: toCurrency, exchangeRate: exchangeRate)
//        
//        // Then
//        XCTAssertEqual(convertedAmount, 0.0, accuracy: 0.01, "Converted amount should be 0.0 for invalid currency code")
//    }
//    
//    // Test fetching exchange rate with invalid data format
//    func testFetchExchangeRateInvalidData() {
//        // Given
//        mockSession.data = MockData.invalidExchangeRateData()
//        mockSession.response = HTTPURLResponse(url: URL(string: "https://yourapi.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
//        mockSession.error = nil
//
//        let expectation = self.expectation(description: "Invalid data format should lead to failure")
//
//        // When
//        sut.getChangeRate { result in
//            // Then
//            if case .failure(let error) = result, case .parsingFailed = error {
//                expectation.fulfill()
//            } else {
//                XCTFail("Expected parsing failure, got \(result) instead")
//            }
//        }
//
//        waitForExpectations(timeout: 5)
//    }
//
//    // Test fetching exchange rate with unauthorized or forbidden error (like 401 or 403 status code)
//    func testFetchExchangeRateUnauthorized() {
//        // Given
//        mockSession.data = nil // In case of 401 or 403, typically no data is returned
//        mockSession.response = HTTPURLResponse(url: URL(string: "https://yourapi.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
//        mockSession.error = nil
//
//        let expectation = self.expectation(description: "Unauthorized status code should lead to failure")
//
//        // When
//        sut.getChangeRate { result in
//            // Then
//            if case .failure(let error) = result, case .httpResponseError = error {
//                expectation.fulfill()
//            } else {
//                XCTFail("Expected httpResponseError, got \(result) instead")
//            }
//        }
//
//        waitForExpectations(timeout: 5)
//    }
//
//    // ... More tests for different HTTP status codes and network conditions
//
//
//    // MARK: - Helpers and Mock Data as in previous example...
//
//}
//
//    // MARK: - Helpers
//
//    enum MockError: Error {
//        case networkError
//        case noData
//        case badData
//        case badResponse
//        case badStatusCode
//        case decodingError
//        case parsingError
//    }
//
//    struct MockData {
//        static func successfulExchangeRateData() -> Data {
//            //   use the json file CurrencyFakeRateData
//            let bundle = Bundle(for: CurrencyViewControllerTests.self)
//            let url = bundle.url(forResource: "CurrencyFakeRateData", withExtension: "json")!
//            return try! Data(contentsOf: url)
//        }
//    }
//
