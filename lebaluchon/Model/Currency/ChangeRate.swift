//
//  CurrencyConverter.swift
//  lebaluchon
//
//  Created by Elodie Gage on 22/11/2023.
//


import Foundation

struct ChangeRate: Codable {
    var date: String
    var rates: Rate
}

struct Rate: Codable {
    var USD: Double
}

class ChangeRateData {

    private struct Keys {
        static let currentChangeRateDate = "currentDate"
        static let currentChangeRate = "currentChangeRate"
    }

    // using UserDefaults to save daily change rate data :
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




