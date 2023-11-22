//
//  CurrencyConverter.swift
//  lebaluchon
//
//  Created by Elodie Gage on 22/11/2023.
//

import Foundation

class CurrencyConverter {
    static func convertCurrency(amount: Double, fromCurrency: String, toCurrency: String, completion: @escaping (Result<Double, AppError>) -> Void) {
        CurrencyService.shared.getCurrencyRate(to: toCurrency, from: fromCurrency, amount: amount) { result in
            switch result {
            case .success(let convertedValue):
                completion(.success(convertedValue))
            case .failure(let error):
                completion(.failure(error as? AppError ?? AppError.apiError))
            }
        }
    }
}
