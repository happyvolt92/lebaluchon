import Foundation

struct WeatherResponse: Codable {
    var weather: [WeatherDetails]
    var main: Temperature
}

struct WeatherDetails: Codable {
    var id: Int
    var description: String
    var icon: String // Add icon field to store the icon name
}

struct Temperature: Codable {
    var temp: Double
}
