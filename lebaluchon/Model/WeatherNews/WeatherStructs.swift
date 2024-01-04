import Foundation

//needed to use codable for testing when mocking test
struct WeatherResponse: Codable {
    var weather: [WeatherDetails]
    var main: Temperature
}

struct WeatherDetails: Codable {
    var id: Int
    var description: String
    var icon: String 
    var iconURL: URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}

struct Temperature: Codable {
    var temp: Double
}
