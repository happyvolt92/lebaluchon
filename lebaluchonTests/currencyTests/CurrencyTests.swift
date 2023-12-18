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
        self.currencyService = ChangeRateService.init(session: urlSessionFake)
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
        let urlSessionFake = URLSessionFake(
            data: FakeChangeRateResponseData.changeRateIncorrectData,
            response: FakeChangeRateResponseData.responseKO,
            error: nil
        )
        self.currencyService.urlSession = urlSessionFake
        currencyService.getChangeRate(to: "USD", from: "EUR", amount: 100) { result in
            switch result {
            case .success:
                XCTFail("Should fail for incorrect data")
            case .failure(let error as lebaluchon.AppError):
                // Adjust the condition to check for the specific error type
                XCTAssertTrue(error == .parsingFailed, "Error should be parsingFailed")
            default:
                XCTFail("Unexpected result")
            }
        }
    }
}
