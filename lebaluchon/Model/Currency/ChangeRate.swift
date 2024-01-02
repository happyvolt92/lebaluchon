//
//  CurrencyConverter.swift
//  lebaluchon
//
//  Created by Elodie Gage on 22/11/2023.
//

import Foundation

// MARK: - Exchange Rate Data Structures

// Structure representing the response from the exchange rate API
struct ChangeRate: Decodable {
    var date: String
    var rates: Rate
}

// Structure representing the exchange rate for a specific currency (e.g., USD)
struct Rate: Decodable {
    var USD: Double
}

// MARK: - Persistent Exchange Rate Data

class ChangeRateData {

    // MARK: - Keys for UserDefaults

    // Keys used for storing exchange rate data in UserDefaults
    struct Keys {
        static let currentChangeRateDate = "currentDate"
        static let currentChangeRate = "currentChangeRate"
    }

    // MARK: - Stored Properties

    // Stored properties to manage the exchange rate data using UserDefaults
    static var changeRateDate: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.currentChangeRateDate) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.currentChangeRateDate)
        }
    }
   
    static var changeRate: Double {
        get {
            return UserDefaults.standard.double(forKey: Keys.currentChangeRate)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.currentChangeRate)
        }
    }
}
