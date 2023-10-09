//
//  WeatherStructs.swift
//  lebaluchon
//
//  Created by Elodie Gage on 09/10/2023.
//

import Foundation

struct Weather: Codable {
    var weather: [WeatherDetails]
    var main: Temperature
}

struct WeatherDetails: Codable {
    var id: Int
    var description: String
}

// separate temperature because I have 2 city to ask 
struct Temperature: Codable {
    var temp: Double
}
