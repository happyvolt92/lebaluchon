import Foundation

struct WeatherResponse: Codable {
    var weather: [WeatherDetails]
    var main: Temperature
}

struct WeatherDetails: Codable {
    var id: Int
    var description: String
}

struct Temperature: Codable {
    var temp: Double
}

struct CityResponse: Codable { 
    let list: [City]
}

struct City: Codable {
    let name: String
    let lat: Double
    let lon: Double
}
