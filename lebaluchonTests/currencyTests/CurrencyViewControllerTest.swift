import XCTest
@testable import lebaluchon

class CurrencyViewControllerTests: XCTestCase {
    
    var sut: CurrencyViewController!
    var sessionMock: URLSessionMock!
    
    override func setUpWithError() throws {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "CurrencyViewController") as? CurrencyViewController
        
        // Setup a mock session and service for network tests
        sessionMock = URLSessionMock(data: nil, response: nil, error: nil)
        
        // Inject mock service into the view controller
        let mockService = ChangeRateService(session: sessionMock)
        sut.changeRateService = mockService
        
        sut.loadViewIfNeeded()
    }
    
    func testConversionLogic() {
        // Given
        let dollarAmount: Double = 100
        let exchangeRate: Double = 1.2
        ChangeRateData.changeRate = exchangeRate
        sut.dollarsTextField.text = "\(dollarAmount)"
        
        // When
        sut.convertDollarsToEuro()
        
        // Then
        let expectedEuroAmount = String(format: "%.2f", dollarAmount / exchangeRate)  // Ensure this is the correct formula used in your actual code.
        XCTAssertEqual(sut.eurosTextField.text, expectedEuroAmount, "Conversion should match expected euro amount")
    }
    
    func testInvalidConversionAmount() {
        // Given
        let invalidAmounts = ["-100", "abc", ""] // Different types of invalid input
        ChangeRateData.changeRate = 1.2 // Assume a valid exchange rate
        
        for amount in invalidAmounts {
            sut.dollarsTextField.text = amount // Set each invalid amount to the text field
            
            // When
            sut.convertDollarsToEuro() // Attempt conversion
            
            // Then
            // Ensure the dollarsTextField still shows the invalid input (as no conversion should happen)
            XCTAssertEqual(sut.dollarsTextField.text, amount, "Dollars text field should still display the invalid input: \(amount)")
           
        }
    }
    
    func testStartLoading() {
        // Given
        let activityIndicator = UIActivityIndicatorView()
        let expectation = XCTestExpectation(description: "Start loading expectation")
        
        // When
        ActivityIndicatorAnimation().startLoading(for: activityIndicator)
        
        // Then
        XCTAssertTrue(activityIndicator.isAnimating, "Activity indicator should be animating after calling startLoading")
        XCTAssertFalse(activityIndicator.isHidden, "Activity indicator should not be hidden after calling startLoading")
        
        // Fulfill the expectation after a delay to simulate async behavior
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testStopLoading() {
        // Given
        let activityIndicator = UIActivityIndicatorView()
        let expectation = XCTestExpectation(description: "Stop loading expectation")
        
        // When
        ActivityIndicatorAnimation().stopLoading(for: activityIndicator)
        
        // Then
        XCTAssertFalse(activityIndicator.isAnimating, "Activity indicator should not be animating after calling stopLoading")
        XCTAssertTrue(activityIndicator.isHidden, "Activity indicator should be hidden after calling stopLoading")
        
        // Fulfill the expectation after a delay to simulate async behavior
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 2.0)
    }

    
    func testFetchChangeRateWithInvalidData() {
        // Given
        let invalidJsonData = "Invalid JSON".data(using: .utf8)!
        sessionMock.data = invalidJsonData
        let expectation = XCTestExpectation(description: "Fetching change rate should fail with invalid data")
        
        // When
        sut.fetchLatestExchangeRate()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.sut.eurosTextField.text, "", "Euro text field should remain empty after fetching invalid data")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        sessionMock = nil
        super.tearDown()
    }
    
    // Helper functions
    private func validChangeRateData() -> Data {
        let json = """
        {
            "date": "2023-01-01",
            "rates": {
                "USD": 1.2
            }
        }
        """.data(using: .utf8)!
        return json
    }
}
