//
//  WeatherServicesFile.swift
//  lebaluchon
//
//  Created by Elodie Gage on 09/10/2023.
//

import Foundation


    class WeatherServices {
        static let shared = WeatherServices()

        enum WeatherCallError: Error {
            case requestError
            case noDataAvailable
            case parsingFailed
            case apiError
            case httpResponseError
        }

        private var session: URLSession
        private let apiKey = "" //

        init(session: URLSession = URLSession(configuration: .default)) {
            self.session = session
        }

        func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, WeatherCallError>) -> Void) {
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

        // Add a function to perform city search
        func performCitySearch(cityName: String?, completion: @escaping (Result<[City], WeatherCallError>) -> Void) {
            guard let cityName = cityName, !cityName.isEmpty else {
                completion(.failure(.requestError))
                return
            }

            guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                completion(.failure(.requestError))
                return
            }

            let url = URL(string: "https://api.openweathermap.org/data/2.5/find?q=\(encodedCityName)&appid=\(apiKey)")!

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
                    let cityResponse = try JSONDecoder().decode(CityResponse.self, from: data)
                    completion(.success(cityResponse.list))
                } catch {
                    completion(.failure(.parsingFailed))
                    print("Parsing error: \(error.localizedDescription)")
                }
            }

            task.resume()
        }
    }
