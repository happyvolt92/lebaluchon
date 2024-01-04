import Foundation

class WeatherServices {
    // Singleton instance for accessing weatherService
    private(set) static var shared = WeatherServices()
    // URLSession to perform network requests
    private var session: URLSession
    // API key for OpenWeatherMap (Replace with your API key)
    private let apiKey = "af8da5af247d50350513bd332859d43c"
    
    // Initialize with a custom URLSession or use the default configuration
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, AppError>) -> Void) {
        // Ensure the city name is properly encoded for the URL
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.requestError))
            return
        }
        // Create the URL for the weather API request with the units=metric parameter
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(apiKey)&units=metric")!
        // Perform a data task to fetch weather data
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error as? URLError {
                // Handle specific URLError cases here
                switch error.code {
                case .timedOut:
                    // Translate URLError timedOut to AppError timeoutError
                    completion(.failure(.timeoutError))
                default:
                    // Handle other URLError cases or provide a generic requestError
                    completion(.failure(.requestError))
                }
                print("URLError occurred: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                // Handle invalid response
                completion(.failure(.httpResponseError))
                return
            }
            guard let data = data else {
                // Handle no data scenario
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                // Attempt to decode the data into a WeatherResponse
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                // Handle parsing error
                completion(.failure(.parsingFailed))
                print("Parsing error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
