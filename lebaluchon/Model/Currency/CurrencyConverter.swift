//
//  CurrencyConverter.swift
//  lebaluchon
//
//  Created by Elodie Gage on 22/11/2023.
//

import Foundation

// MARK: - CurrencyConverter

struct CurrencyConverter {

    // This property stores the current exchange rate between USD and EUR
    let currencyRate: Double

    // Designated initializer
    init(currencyRate: Double) {
        self.currencyRate = currencyRate
    }

    // Method to convert USD to EUR
    func convertUSDToEUR(amount: Double) -> Double {
        // Multiply the USD amount by the currency rate to get the equivalent EUR amount
        let convertedAmount = amount * currencyRate

        // Return the converted amount
        return convertedAmount
    }
}
