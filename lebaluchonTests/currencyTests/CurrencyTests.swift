import XCTest
@testable import lebaluchon

class CurrencyServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    var currencyService: CurrencyService!
    
    // MARK: - Setup
    
    override func setUpWithError() throws {
        // Use URLSessionFake for testing
        let urlSessionFake = URLSessionFake(
            data: FakeChangeRateResponseData().changeRateCorrectData(),
            response: FakeChangeRateResponseData.responseOK,
            error: nil
        )
        self.currencyService = CurrencyService.init(session: urlSessionFake)
    }
    
    // MARK: - Tests
    
    
//    use the url
    func testGetCurrencyRateSuccess() {
        // Given
//        let expectation = XCTestExpectation(description: "Currency conversion successful")

        // When
        currencyService.getCurrencyRate(to: "USD", from: "EUR", amount: 100) { result in
             switch result {
             case .success(let convertedValue):
                 print("Converted value: \(convertedValue)")
                 XCTAssertEqual(convertedValue, 1.131164, accuracy: 0.001)
//                 expectation.fulfill()

             case .failure:
                 XCTFail("Should not fail for successful conversion")
             }
        }
        
//        wait(for: [expectation], timeout: 20.0) // Increased timeout value
    }
    
    func testGetCurrencyRateFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Currency conversion should fail")
        let fakeData = FakeChangeRateResponseData.changeRateIncorrectData
        let fakeResponse = FakeChangeRateResponseData.responseKO
        
        // When
        currencyService.getCurrencyRate(to: "USD", from: "EUR", amount: 100) { result in
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
