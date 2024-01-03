////
////  CurrencyViewControllerTest.swift
////  lebaluchonTests
////
////  Created by Elodie Gage on 03/01/2024.
////
//
//import XCTest
//@testable import lebaluchon
//
//class CurrencyViewControllerTests: XCTestCase {
//
//    var sut: CurrencyViewController!
//
//    override func setUpWithError() throws {
//        super.setUp()
//        sut = CurrencyViewController()
//        sut.loadViewIfNeeded() // To ensure all outlets are loaded
//    }
//
//    override func tearDownWithError() throws {
//        sut = nil
//        super.tearDown()
//    }
//
//    // Test conversion logic
//    func testConversionLogic() {
//        // Given
//        let dollarAmount: Double = 100
//        let exchangeRate: Double = 0.85 // Example exchange rate
//        ChangeRateData.changeRate = exchangeRate
//        sut.dollarsTextField.text = "\(dollarAmount)"
//
//        // When
//        sut.convertDollarsToEuro()
//
//        // Then
//        let expectedEuroAmount = String(format: "%.2f", dollarAmount * exchangeRate)
//        XCTAssertEqual(sut.eurosTextField.text, expectedEuroAmount)
//    }
//    
//    // Test handling invalid conversion amount (e.g., negative, non-numeric)
//    func testInvalidConversionAmount() {
//        // Given
//        sut.dollarsTextField.text = "-100" // Negative value
//
//        // When
//        sut.convertDollarsToEuro()
//
//        // Then
//        XCTAssertEqual(sut.eurosTextField.text, "", "Euro text field should remain empty or show an error for invalid amount.")
//    }
//
//    // Test if conversion doesn't proceed when exchange rate data is outdated
//    func testConversionWithOutdatedExchangeRate() {
//        // Given
//        ChangeRateData.changeRateDate = "2022-01-01" // An old date
//        sut.dollarsTextField.text = "100"
//
//        // When
//        sut.convertDollarsToEuro()
//
//        // Then
//        // The actual implementation of the test will depend on how you handle outdated data.
//        // Typically, this would involve checking if a fetch request is made or if an error is shown.
//    }
//
//    // Test visibility of activity indicator when fetching data
//    func testActivityIndicatorVisibilityDuringFetch() {
//        // Given
//        let expectation = XCTestExpectation(description: "Activity indicator should be visible during data fetch")
//
//        // When
//        sut.fetchLatestExchangeRate()
//
//        // Then
//        XCTAssertTrue(sut.activityIndicator.isAnimating, "Activity indicator should be animating while fetching data")
//        // Wait for fetch to complete then test that it stops animating
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            XCTAssertFalse(self.sut.activityIndicator.isAnimating, "Activity indicator should stop animating after fetch")
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 3)
//    }
//}
