import XCTest
@testable import lebaluchon

class CurrencyServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    var currencyService: ChangeRateService!
    
    // MARK: - Setup
    
    override func setUpWithError() throws {
        // Use URLSessionFake for testing
        let urlSessionFake = URLSessionFake(
            data: FakeChangeRateResponseData().changeRateCorrectData(),
            response: FakeChangeRateResponseData.responseOK,
            error: nil
        )
        self.currencyService = ChangeRateService(session: urlSessionFake)
    }
    
    // MARK: - Tests
    
    func testGetChangeRateSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Change rate retrieval successful")
        
        // When
        currencyService.getChangeRate { result in
            switch result {
            case .success(let changeRate):
                print("Change rate retrieved: \(changeRate)")
                XCTAssertNotNil(changeRate)
                expectation.fulfill()
                
            case .failure:
                XCTFail("Should not fail for successful change rate retrieval")
            }
        }
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testGetCurrencyRateFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Currency conversion should fail")
        
        // Use URLSessionFake for testing with incorrect data and response
        let urlSessionFake = URLSessionFake(
            data: FakeChangeRateResponseData.changeRateIncorrectData,
            response: FakeChangeRateResponseData.responseKO,
            error: nil
        )
        self.currencyService = ChangeRateService(session: urlSessionFake)

        // When
        currencyService.getChangeRate { result in
            // Then
            switch result {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, .httpResponseError) // You should modify this to match your expected error type.
                expectation.fulfill()
            }
        }

        // Wait for the expectation to be fulfilled within a certain time interval (adjust the timeout as needed).
        wait(for: [expectation], timeout: 5.0)
    }

}
