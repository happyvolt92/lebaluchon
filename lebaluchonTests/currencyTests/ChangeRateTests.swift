import XCTest
@testable import lebaluchon


// MARK: - ChangeRateTests
final class ChangeRateTests: XCTestCase {
    
    var mockSession: URLSessionMock!
    var serviceUnderTest: ChangeRateService!
    
    override func setUpWithError() throws {
        super.setUp()
        mockSession = URLSessionMock(data: nil, response: nil, error: nil)
        serviceUnderTest = ChangeRateService(session: mockSession)
    }
    
    func testFetchChangeRateSuccess() {
        // Given
        let jsonData = """
        {
            "date": "2023-11-15",
            "rates": {
                "USD": 1.131164
            }
        }
        """.data(using: .utf8)!
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.error = nil
        
        let expectation = self.expectation(description: "ChangeRateService fetches data and parses it to ChangeRate object")
        
        // When
        serviceUnderTest.getChangeRate { result in
            switch result {
            case .success(let changeRate):
                XCTAssertEqual(changeRate.date, "2023-11-15")
                XCTAssertEqual(changeRate.rates.USD, 1.131164)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("The call to fetchChangeRate failed with error: \(error.localizedDescription)")
            }
        }
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchChangeRateFailure() {
        // Given
        mockSession.data = nil
        mockSession.response = nil
        mockSession.error = NSError(domain: "", code: 0, userInfo: nil)
        
        let expectation = self.expectation(description: "ChangeRateService completes with a failure due to network error")
        
        // When
        serviceUnderTest.getChangeRate { result in
            if case .failure = result {
                expectation.fulfill()
            } else {
                XCTFail("Expected fetchChangeRate to complete with error, but succeeded")
            }
        }
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchChangeRateFailureDueToNetworkError() {
        // Given
        mockSession.data = nil
        mockSession.response = nil
        mockSession.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        
        let expectation = self.expectation(description: "ChangeRateService should fail due to network error")
        
        // When
        serviceUnderTest.getChangeRate { result in
            if case .failure = result {
                expectation.fulfill()
            } else {
                XCTFail("Expected fetchChangeRate to fail due to network error")
            }
        }
        
        // Then
        waitForExpectations(timeout: 5)
    }
    
    func testFetchChangeRateFailureDueToInvalidJSON() {
        // Given
        let invalidJSONData = "Invalid JSON".data(using: .utf8)!
        mockSession.data = invalidJSONData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.error = nil
        
        let expectation = self.expectation(description: "ChangeRateService should fail due to invalid JSON")
        
        // When
        serviceUnderTest.getChangeRate { result in
            if case .failure = result {
                expectation.fulfill()
            } else {
                XCTFail("Expected fetchChangeRate to fail due to invalid JSON")
            }
        }
        
        // Then
        waitForExpectations(timeout: 5)
    }
   
    
    override func tearDownWithError() throws {
        mockSession = nil
        serviceUnderTest = nil
        super.tearDown()
    }
}
