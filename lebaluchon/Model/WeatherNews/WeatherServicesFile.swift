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

    // Fetch weather data for a specified city
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, AppError>) -> Void) {
        // Ensure the city name is properly encoded for the URL
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.requestError))
            return
        }

        // Create the URL for the weather API request
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(apiKey)")!

        // Perform a data task to fetch weather data
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
                // Decode the weather response from JSON
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(.parsingFailed))
                print("Parsing error: \(error.localizedDescription)")
            }
        }

        // Start the data task
        task.resume()
    }

    // Perform a city search to get a list of matching cities
    func performCitySearch(cityName: String?, completion: @escaping (Result<[City], AppError>) -> Void) {
        // Ensure a valid city name is provided
        guard let cityName = cityName, !cityName.isEmpty else {
            completion(.failure(.requestError))
            return
        }

        // Encode the city name for the URL
        guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.requestError))
            return
        }

        // Create the URL for the city search API request
        let url = URL(string: "https://api.openweathermap.org/data/2.5/find?q=\(encodedCityName)&appid=\(apiKey)")!

        // Perform a data task to fetch city search results
        let task = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
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
                    // Decode the city search response from JSON
                    let cityResponse = try JSONDecoder().decode(CityResponse.self, from: data)
                    completion(.success(cityResponse.list))
                } catch {
                    completion(.failure(.parsingFailed))
                    print("\(#file)Parsing error: \(error.localizedDescription)")
                }
            }
          
        }

        // Start the data task
        task.resume()
    }
}
