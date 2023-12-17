//
//  CurrencyResponse.swift
//  lebaluchon
//
//  Created by Elodie Gage on 27/10/2023.
//
import Foundation

struct CurrencyResponse: Codable {
    var date: String
    var rates: Rate
}

struct Rate: Codable {
    var USD: Double
}

