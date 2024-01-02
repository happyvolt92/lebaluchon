import Foundation

struct WeatherResponse: Decodable {
    var weather: [WeatherDetails]
    var main: Temperature
}

struct WeatherDetails: Decodable {
    var id: Int
    var description: String
    var icon: String 
    var iconURL: URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}

struct Temperature: Decodable {
    var temp: Double
}
