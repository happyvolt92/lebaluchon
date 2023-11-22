// CurrencyService.swift
import Foundation

class CurrencyService {
    public static let shared = CurrencyService()
    var urlSession: URLSession = URLSession.shared
    
    public init() { }
    
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
                completion(.failure(AppError.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let conversionResponse = try decoder.decode(CurrencyConversionResponse.self, from: data)
                completion(.success(conversionResponse.result))
            } catch {
                completion(.failure(AppError.parsingFailed))
            }
        }.resume()
    }
}

struct CurrencyConversionResponse: Codable {
    let success: Bool
    let result: Double
}
