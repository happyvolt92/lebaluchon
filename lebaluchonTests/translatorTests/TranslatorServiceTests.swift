@testable import lebaluchon
import XCTest

class TranslatorServiceTests: XCTestCase {
    
    private let testText = "Hello Steve"
    
    func testGetTranslatorShouldPostFailedCallbackIfError() {
        // Given
        let expectation = XCTestExpectation(description: "API call should fail with apiError")
        let translatorServiceForTest = TranslatorService.shared
        
        // When
        translatorServiceForTest.getTextTranslation(textToTranslate: testText, from: .english) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .apiError)
            case .success:
                XCTFail("Request should fail with apiError")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetTraductorShouldPostFailedCallbackIfNoDataAvailable() {
        // Given
        let expectation = XCTestExpectation(description: "API call should fail with noDataAvailable")
        let translatorServiceFakeTest = TranslatorService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        translatorServiceFakeTest.getTextTranslation(textToTranslate: testText, from: .english) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noDataAvailable)
            case .success:
                XCTFail("Request should fail with noDataAvailable")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetTraductorShouldPostFailedCallbackIfCorrectDataButIncorrectResponse() {
        // Given
        let expectation = XCTestExpectation(description: "API call should fail with httpResponseError")
        let translatorServiceFakeTest = TranslatorService(session: URLSessionFake(data: FakeTranslatorResponseData.translatorCorrectData, response: FakeTranslatorResponseData.responseKO, error: nil))
        
        // When
        translatorServiceFakeTest.getTextTranslation(textToTranslate: testText, from: .english) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .httpResponseError)
            case .success:
                XCTFail("Request should fail with httpResponseError")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetTraductorShouldPostFailedCallbackIfCorrectResponseButIncorrectData() {
        // Given
        let expectation = XCTestExpectation(description: "API call should fail with parsingFailed")
        let translatorServiceFakeTest = TranslatorService(session: URLSessionFake(data: FakeTranslatorResponseData.translatorIncorrectData, response: FakeTranslatorResponseData.responseOK, error: nil))
        
        // When
        translatorServiceFakeTest.getTextTranslation(textToTranslate: testText, from: .english) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .parsingFailed)
            case .success:
                XCTFail("Request should fail with parsingFailed")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetTraductorShouldPostFailedCallbackIfNoErrorAndCorrectResponseAndCorrectDataButRequestBuildingFailed() {
        // Given
        let expectation = XCTestExpectation(description: "API call should fail with requestError")
        let translatorServiceFakeTest = TranslatorService(session: URLSessionFake(data: FakeTranslatorResponseData.translatorCorrectData, response: FakeTranslatorResponseData.responseOK, error: nil))
        
        // When
        translatorServiceFakeTest.getTextTranslation(textToTranslate: nil, from: .french) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .requestError)
            case .success:
                XCTFail("Request should fail with requestError")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetTraductorShouldPostSuccessfulCallbackIfNoErrorAndCorrectResponseAndCorrectData() {
        // Given
        let expectation = XCTestExpectation(description: "API call should succeed")
        let translatorServiceFakeTest = TranslatorService(session: URLSessionFake(data: FakeTranslatorResponseData.translatorCorrectData, response: FakeTranslatorResponseData.responseOK, error: nil))
        
        // When
        translatorServiceFakeTest.getTextTranslation(textToTranslate: testText, from: .english) { result in
            // Then
            let translatedText = "Bonjour Steve"
            switch result {
            case .failure:
                XCTFail("Request shouldn't fail")
            case .success(let translator):
                XCTAssertNotNil(translator)
                XCTAssertEqual(translatedText, translator.data.translations.first!.translatedText)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
