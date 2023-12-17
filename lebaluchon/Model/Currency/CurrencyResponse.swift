//
//  CurrencyResponse.swift
//  lebaluchon
//
//  Created by Elodie Gage on 27/10/2023.
//
import Foundation

// MARK: - Welcome
struct CurrencyResponse: Codable {
    let success: Bool
    let timestamp: Int
    let base, date: String
    let rates: Rates
}

// MARK: - Rates
struct Rates: Codable {
    let usd: Double
    let eur: Double

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case eur = "EUR"
    }
}
