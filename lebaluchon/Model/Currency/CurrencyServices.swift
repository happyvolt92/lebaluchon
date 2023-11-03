import Foundation

class CurrencyService {
    static let shared = CurrencyService()
    
    private init() { }
    
    func getCurrencyRate(to: String, from: String, amount: Double, completion: @escaping (Result<Double, Error>) -> Void) {
        let baseURL = "https://api.apilayer.com/fixer/convert"
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "to", value: to),
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "amount", value: String(amount))
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue("XZ9Zc4KWjZcR7QArcf2hB7I7UzOx05XC", forHTTPHeaderField: "apikey")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "AppError", code: -1, userInfo: nil)))
                return
            }
            
            do {
                // Use a JSON decoder to parse the API response
                let decoder = JSONDecoder()
                let convertedValue = try decoder.decode(CurrencyConversionResponse.self, from: data)
                completion(.success(convertedValue.result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct CurrencyConversionResponse: Codable {
    let success: Bool
    let result: Double
}
