struct WeatherResponse: Codable {
    var weather: [WeatherDetails]
    var main: Temperature
}

struct WeatherDetails: Codable {
    var id: Int
    var description: String
}

// Separate temperature because I have 2 cities to ask
struct Temperature: Codable {
    var temp: Double
}

struct CityResponse: Codable { // Add the missing CityResponse struct
    let list: [City]
}

struct City: Codable {
    let name: String
    let lat: Double
    let lon: Double
}
