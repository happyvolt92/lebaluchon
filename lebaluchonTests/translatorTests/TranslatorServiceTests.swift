//
//  TranslatorServiceTests.swift
//  lebaluchonTests
//
//  Created by Elodie Gage on 17/11/2023.
//

@testable import lebaluchon
import XCTest

class TraductorServiceTestCase: XCTestCase {
    
    private let testText = "Hello Steve"
    
    func testGetTranslatorShouldPostFailedCallbackIfError() {
        // Given
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
        }
    }
    func testGetTraductorShouldPostFailedCallbackIfNoDataAvailable() {
        // Given
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
        }
    }
    
    func testGetTraductorShouldPostFailedCallbackIfCorrectDataButIncorrectResponse() {
        // Given
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
        }
    }
    
    func testGetTraductorShouldPostFailedCallbackIfCorrectResponseButIncorrectData() {
        // Given
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
        }
    }
    
    func testGetTraductorShouldPostFailedCallbackIfNoErrorAndCorrectResponseAndCorrectDataButRequestBuildingFailed() {
        // Given
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
        }
    }
    
    func testGetTraductorShouldPostSuccessfulCallbackIfNoErrorAndCorrectResponseAndCorrectData() {
        // Given
        let translatorServiceFakeTest = TranslatorService(session: URLSessionFake(data: FakeTranslatorResponseData.translatorCorrectData, response: FakeTranslatorResponseData.responseOK, error: nil))
        // When
        translatorServiceFakeTest.getTextTranslation(textToTranslate: testText, from: .english) { result in
            // Then
            let translatedText = "Bonjour Steve"
            switch result {
            case .failure:
                XCTFail("Request shouldn't fail")
            case .success(let traductor):
                XCTAssertNotNil(traductor)
                XCTAssertEqual(translatedText, traductor.data.translations.first!.translatedText)
            }
        }
    }
}
