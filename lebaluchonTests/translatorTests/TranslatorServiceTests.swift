@testable import lebaluchon
import XCTest

class TranslatorServiceTests: XCTestCase {
    
    class URLSessionMock: URLSession {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        init(data: Data?, response: URLResponse?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            let task = URLSessionDataTaskMock(
                data: data,
                urlResponse: response,
                responseError: error,
                completionHandler: completionHandler
            )
            return task
        }
    }

    class URLSessionDataTaskMock: URLSessionDataTask {
        var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

        var data: Data?
        var urlResponse: URLResponse?
        var responseError: Error?

        init(data: Data?, urlResponse: URLResponse?, responseError: Error?, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
            self.completionHandler = completionHandler
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
        }

        override func resume() {
            completionHandler?(data, urlResponse, responseError)
        }
    }

    
    private let testText = "Hello Steve"
    
    func testGetTranslatorShouldPostFailedCallbackIfError() {
        // Given
        let urlSessionMock = URLSessionMock(data: nil, response: nil, error: AppError.apiError)
        let translatorServiceForTest = TranslatorService(session: urlSessionMock)
        let expectation = XCTestExpectation(description: "API call should fail with apiError")
        
        // When
        translatorServiceForTest.getTextTranslation(textToTranslate: testText, from: .english) { result in
            // Then
            switch result {
            case .failure(let error):
                // Directly compare the error without casting as it's already the expected type.
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
        
        wait(for: [expectation], timeout: 0.5)
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
                XCTAssertEqual(error, .noDataAvailable)
            case .success:
                XCTFail("Request should fail with httpResponseError")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
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
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testGetTraductorShouldPostFailedCallbackIfNoErrorAndCorrectResponseAndCorrectDataButRequestBuildingFailed() {
        // Given
        let expectation = XCTestExpectation(description: "API call should fail with requestError")
        let translatorServiceFakeTest = TranslatorService(session: URLSessionFake(data: FakeTranslatorResponseData.translatorCorrectData, response: FakeTranslatorResponseData.responseOK, error: nil))
        
        // When
        translatorServiceFakeTest.getTextTranslation(textToTranslate: testText, from: .french) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .requestError )
            case .success:
                XCTFail("Request should fail with requestError")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
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
        
        wait(for: [expectation], timeout: 0.5)
    }
}
