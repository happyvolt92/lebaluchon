@testable import lebaluchon
import XCTest

class TranslatorServiceTests: XCTestCase {
    
    private var translatorService: TranslatorService!
    private let testText = "Hello Steve"
    
    override func setUp() {
        super.setUp()
        translatorService = TranslatorService(session: URLSessionFake(data: nil, response: nil, error: nil))
    }
    
    // Test 1: Simulate network error
    func testGetTranslatorShouldPostFailedCallbackIfError() {
        let error = NSError(domain: "network", code: 0, userInfo: nil)
        translatorService.session = URLSessionFake(data: nil, response: nil, error: error)
        
        let expectation = XCTestExpectation(description: "Waiting for translation to fail due to network error.")
        translatorService.getTextTranslation(textToTranslate: testText, from: .english) { result in
            if case .failure = result {
                XCTAssert(true, "Failure was expected due to network error.")
            } else {
                XCTFail("Expected network error did not occur.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Test 2: Simulate no data being available
    func testGetTranslatorShouldPostFailedCallbackIfNoDataAvailable() {
        translatorService.session = URLSessionFake(data: nil, response: nil, error: nil)
        let expectation = XCTestExpectation(description: "Waiting for translation to fail due to no data.")
        translatorService.getTextTranslation(textToTranslate: testText, from: .english) { result in
            if case .failure = result {
                XCTAssert(true, "Failure was expected due to no data.")
            } else {
                XCTFail("Expected no data error did not occur.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Test 3: Simulate incorrect response but correct data
    func testGetTranslatorShouldPostFailedCallbackIfCorrectDataButIncorrectResponse() {
        translatorService.session = URLSessionFake(data: FakeTranslatorResponseData.translatorCorrectData, response: FakeTranslatorResponseData.responseKO, error: nil)
        let expectation = XCTestExpectation(description: "Waiting for translation to fail due to incorrect response.")
        translatorService.getTextTranslation(textToTranslate: testText, from: .english) { result in
            if case .failure = result {
                XCTAssert(true, "Failure was expected due to incorrect response.")
            } else {
                XCTFail("Expected incorrect response error did not occur.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Test 4: Simulate correct response but incorrect data
    func testGetTranslatorShouldPostFailedCallbackIfCorrectResponseButIncorrectData() {
        translatorService.session = URLSessionFake(data: FakeTranslatorResponseData.translatorIncorrectData, response: FakeTranslatorResponseData.responseOK, error: nil)
        let expectation = XCTestExpectation(description: "Waiting for translation to fail due to incorrect data.")
        translatorService.getTextTranslation(textToTranslate: testText, from: .english) { result in
            if case .failure = result {
                XCTAssert(true, "Failure was expected due to incorrect data.")
            } else {
                XCTFail("Expected incorrect data error did not occur.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Test 5: Simulate all correct but request building failed
    func testGetTraductorShouldPostFailedCallbackIfNoErrorAndCorrectResponseAndCorrectDataButRequestBuildingFailed() {
        // Simulate a scenario where request building fails (e.g., wrong URL or parameters)
        // Implement as per your TranslatorService's request building logic
        // For now, assuming request building fails when an empty text is provided
        translatorService.session = URLSessionFake(data: FakeTranslatorResponseData.translatorCorrectData, response: FakeTranslatorResponseData.responseKO, error: nil)
        let expectation = XCTestExpectation(description: "Waiting for translation to fail due to request building failure.")
        translatorService.getTextTranslation(textToTranslate: "", from: .english) { result in
            if case .failure = result {
                XCTAssert(true, "Failure was expected due to request building failure.")
            } else {
                XCTFail("Expected request building error did not occur.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Test 6: Simulate successful response with correct data
    func testGetTranslatorShouldPostSuccessfulCallbackIfNoErrorAndCorrectResponseAndCorrectData() {
        translatorService.session = URLSessionFake(data: FakeTranslatorResponseData.translatorCorrectData, response: FakeTranslatorResponseData.responseOK, error: nil)
        let expectation = XCTestExpectation(description: "Waiting for successful translation.")
        translatorService.getTextTranslation(textToTranslate: testText, from: .english) { result in
            switch result {
            case .success(let translationData):
                XCTAssertEqual(translationData.data.translations[0].translatedText, "Bonjour Steve", "Translation should match expected value.")
            case .failure:
                XCTFail("Expected successful translation did not occur.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    override func tearDown() {
        translatorService = nil
        super.tearDown()
    }
}
