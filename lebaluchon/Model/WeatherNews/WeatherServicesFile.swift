import Foundation

class WeatherServices {
    // Singleton instance
    static let shared = WeatherServices()
    // URLSession to perform network requests
    private var session: URLSession
    // API key for OpenWeatherMap (Replace with your API key)
    private let apiKey = "af8da5af247d50350513bd332859d43c"

    // Initialize with a custom URLSession or use the default configuration
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, AppError>) -> Void) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.requestError))
            return
        }

        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(apiKey)")!

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestError))
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                completion(.failure(.noDataAvailable))
                return
            }

            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(.parsingFailed))
                print("Parsing error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}
