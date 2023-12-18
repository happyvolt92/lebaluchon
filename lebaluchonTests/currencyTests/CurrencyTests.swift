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
    
    func testGetChangeRateFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Change rate retrieval should fail")
        _ = FakeChangeRateResponseData.changeRateIncorrectData
        _ = FakeChangeRateResponseData.responseKO
        
        // When
        currencyService.getChangeRate { result in
            switch result {
            case .success:
                XCTFail("Should fail for incorrect data")

            case .failure(let error):
                print("Error received: \(error)")
                XCTAssertTrue(error is FakeChangeRateResponseData.FakeChangeRateError)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 20.0)
    }
}
