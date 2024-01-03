////
//// CurrencyTest.swift
////
//// created by Elodie GAGE on 22/12/23
////
//
import XCTest
@testable import lebaluchon

class ChangeRateServiceTests: XCTestCase {
    
    var sut: ChangeRateService!
    var mockSession: URLSessionFake!
    
    override func setUpWithError() throws {
        super.setUp()
        mockSession = URLSessionFake(data: nil, response: nil, error: nil)
        sut = ChangeRateService(session: mockSession) // Ensure ChangeRateService can be initialized with a session
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testFetchExchangeRateSuccess() {
        // Given
        let fakeData = FakeChangeRateResponseData()
        let data = fakeData.changeRateCorrectData()
        let response = FakeChangeRateResponseData.responseOK
        mockSession.data = data
        mockSession.response = response
        mockSession.error = nil
        
        let expectation = self.expectation(description: "Successful fetch of exchange rate")
        
        // When
        sut.getChangeRate { result in
            switch result {
            case .success(let rate):
                // Then
                XCTAssertNotNil(rate)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, got \(result) instead")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testFetchExchangeRateWithNetworkError() {
        // Given
        mockSession.error = FakeChangeRateResponseData.error
        
        let expectation = self.expectation(description: "Network error while fetching exchange rate")
        
        // When
        sut.getChangeRate { result in
            if case .failure(let error) = result {
                // Then
                XCTAssertNotNil(error)
                expectation.fulfill()
            } else {
                XCTFail("Expected failure, got \(result) instead")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    // Test fetching exchange rate with invalid data format
    func testFetchExchangeRateInvalidData() {
        // Given
        mockSession.data = FakeChangeRateResponseData.changeRateIncorrectData
        mockSession.response = FakeChangeRateResponseData.responseOK
        mockSession.error = nil
        
        let expectation = self.expectation(description: "Invalid data format should lead to failure")
        
        // When
        sut.getChangeRate { result in
            // Then
            if case .failure(let error) = result, case .parsingFailed = error {
                expectation.fulfill()
            } else {
                XCTFail("Expected parsing failure, got \(result) instead")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    // Test fetching exchange rate with unauthorized or forbidden error (like 401 or 403 status code)
    func testFetchExchangeRateUnauthorized() {
        // Given
        mockSession.data = nil // In case of 401 or 403, typically no data is returned
        mockSession.response = FakeChangeRateResponseData.responseKO // Simulate an error response
        mockSession.error = nil
        
        let expectation = self.expectation(description: "Unauthorized status code should lead to failure")
        
        // When
        sut.getChangeRate { result in
            // Then
            if case .failure(let error) = result, case .httpResponseError = error {
                expectation.fulfill()
            } else {
                XCTFail("Expected httpResponseError, got \(result) instead")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
        
    // Test fetching exchange rate with an unexpected status code like 500 (Internal Server Error)
    func testFetchExchangeRateUnexpectedStatusCode() {
        // Given
        let unexpectedStatusCodeResponse = HTTPURLResponse(url: URL(string: "https://yourapi.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
        mockSession.data = nil
        mockSession.response = unexpectedStatusCodeResponse
        mockSession.error = nil
        
        let expectation = self.expectation(description: "Unexpected status code should lead to failure")
        
        // When
        sut.getChangeRate { result in
            // Then
            if case .failure(let error) = result, case .httpResponseError = error {
                expectation.fulfill()
            } else {
                XCTFail("Expected httpResponseError, got \(result) instead")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    // Test fetching exchange rate when server returns correct status code but no data
    func testFetchExchangeRateNoData() {
        // Given
        mockSession.data = nil
        mockSession.response = FakeChangeRateResponseData.responseOK
        mockSession.error = nil
        
        let expectation = self.expectation(description: "No data should lead to failure")
        
        // When
        sut.getChangeRate { result in
            // Then
            if case .failure(let error) = result, case .noDataAvailable = error {
                expectation.fulfill()
            } else {
                XCTFail("Expected noDataAvailable, got \(result) instead")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    // Test fetching exchange rate when data is returned but it's completely malformed
    func testFetchExchangeRateCompletelyMalformedData() {
        // Given
        let completelyMalformedData = "Not a JSON".data(using: .utf8)!
        mockSession.data = completelyMalformedData
        mockSession.response = FakeChangeRateResponseData.responseOK
        mockSession.error = nil
        
        let expectation = self.expectation(description: "Completely malformed data should lead to failure")
        
        // When
        sut.getChangeRate { result in
            // Then
            if case .failure(let error) = result, case .parsingFailed = error {
                expectation.fulfill()
            } else {
                XCTFail("Expected parsingFailed, got \(result) instead")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    // Test fetching exchange rate with a valid response but unexpected JSON structure
    func testFetchExchangeRateUnexpectedJSONStructure() {
        // Given
        let unexpectedJSONData = "{\"unexpected\":\"structure\"}".data(using: .utf8)!
        mockSession.data = unexpectedJSONData
        mockSession.response = FakeChangeRateResponseData.responseOK
        mockSession.error = nil
        
        let expectation = self.expectation(description: "Unexpected JSON structure should lead to failure")
        
        // When
        sut.getChangeRate { result in
            // Then
            if case .failure(let error) = result, case .parsingFailed = error {
                expectation.fulfill()
            } else {
                XCTFail("Expected parsingFailed, got \(result) instead")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
}
