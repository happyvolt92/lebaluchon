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
        currencyService.getCurrencyRate(to: "USD", from: "EUR", amount: 100) { result in
            switch result {
            case .success(let convertedValue):
                print("Converted value: \(convertedValue)")
                 XCTAssertEqual(convertedValue, 1.131164, accuracy: 0.001)
            case .failure:
                XCTFail("Should not fail for successful conversion")
            }
        }
    }
    func testGetCurrencyRateFailure() {
        let urlSessionFake = URLSessionFake(
            data: FakeChangeRateResponseData.changeRateIncorrectData,
            response: FakeChangeRateResponseData.responseKO,
            error: nil
        )
        self.currencyService.urlSession = urlSessionFake
        
        currencyService.getCurrencyRate(to: "USD", from: "EUR", amount: 100) { result in
            switch result {
            case .success:
                XCTFail("Should fail for incorrect data")

            case .failure(let error):
                switch error {
                case lebaluchon.AppError.parsingFailed:
                    XCTAssertTrue(true, "Error should be parsingFailed")
                default:
                    XCTFail("Unexpected error")
                }
            }
        }
    }

}
