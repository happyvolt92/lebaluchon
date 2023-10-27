

import Foundation

    class CurrencyService {

        static let shared = CurrencyService()
        
        private let apiKey = "XZ9Zc4KWjZcR7QArcf2hB7I7UzOx05XC" // R
        private let baseURL = "http://data.fixer.io/api/latest"
        
        private init() { }
        
        func getCurrencyRate(completion: @escaping (Result<CurrencyResponse, Error>) -> Void) {
            let urlString = "\(baseURL)?access_key=\(apiKey)&symbols=USD"
            
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "AppError", code: -1, userInfo: nil)))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let currencyResponse = try decoder.decode(CurrencyResponse.self, from: data)
                        completion(.success(currencyResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
