//
//  errors.swift
//  lebaluchon
//
//  Created by Elodie Gage on 13/10/2023.
//

import Foundation
import UIKit



enum AppError: Error {
    case requestError
    case noDataAvailable
    case parsingFailed
    case apiError
    case httpResponseError
    case emptyAmount
    case incorrectAmount
    case jsonParsingError
    case timeoutError
}

extension UIViewController {
    func showAlert(for error: AppError) {
        let title: String
        let message: String

        switch error {
        case .requestError:
            title = "Request Error"
            message = "There was an error in the request."
        case .noDataAvailable:
            title = "No Data Available"
            message = "No data is available."
        case .parsingFailed:
            title = "Parsing Failed"
            message = "Failed to parse the data."
        case .apiError:
            title = "API Error"
            message = "An error occurred with the API."
        case .httpResponseError:
            title = "HTTP Response Error"
            message = "Error in the HTTP response."
        case .emptyAmount:
            title = " Empty Field"
            message = "Please give some Integer to convert"
        case .incorrectAmount:
            title = " Incorrect Amount"
            message = "We convert only numbers"
        case .jsonParsingError:
            title = "JSON Parsing Error"
            message = "Failed to parse the JSON response."
        case .timeoutError:
            title = "Timeout Error"
            message = "The rsquest timout."
        }
        showAlert(title: title, message: message)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }
}

