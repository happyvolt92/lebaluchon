////
//// CurrencyTest.swift
////
//// created by Elodie GAGE on 22/12/23
////
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
    // ____ MockUserDefault
    
    // MockUserDefaults to be used in tests
    class MockUserDefaults: UserDefaults {
        var mockData = [String: Any]()
        
        override func string(forKey defaultName: String) -> String? {
            return mockData[defaultName] as? String
        }
        
        override func double(forKey defaultName: String) -> Double {
            return mockData[defaultName] as? Double ?? 0
        }
        
        override func set(_ value: Any?, forKey defaultName: String) {
            mockData[defaultName] = value
        }
    }    
       
//        func testChangeRateDateGetter() {
//            let expectedDate = "2023-11-15"
//            MockUserDefaults.mockData[ChangeRateData.Keys.currentChangeRateDate] = expectedDate
//            let date = ChangeRateData.changeRateDate
//            XCTAssertEqual(date, expectedDate, "The getter should return the date stored in UserDefaults")
//        }
//        
//        func testChangeRateDateSetter() {
//            let newDate = "2023-11-16"
//            ChangeRateData.changeRateDate = newDate
//            XCTAssertEqual(MockUserDefaults.mockData[ChangeRateData.Keys.currentChangeRateDate] as? String, newDate, "The setter should store the new date in UserDefaults")
//        }
//        
//        func testChangeRateGetter() {
//            let expectedRate: Double = 1.131164
//            MockUserDefaults.mockData[ChangeRateData.Keys.currentChangeRate] = expectedRate
//            let rate = ChangeRateData.changeRate
//            XCTAssertEqual(rate, expectedRate, "The getter should return the rate stored in UserDefaults")
//        }
//        
//        func testChangeRateSetter() {
//            let newRate: Double = 1.2
//            ChangeRateData.changeRate = newRate
//            XCTAssertEqual(MockUserDefaults.mockData[ChangeRateData.Keys.currentChangeRate] as? Double, newRate, "The setter should store the new rate in UserDefaults")
//        }

    
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
        mockSession.data = FakeChangeRateResponseData.changeRateIncorrectData()
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
            if case .failure(let error) = result, case .noDataAvailable = error {
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
            if case .failure(let error) = result, case .noDataAvailable = error {
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
