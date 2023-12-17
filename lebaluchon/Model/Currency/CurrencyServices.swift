import Foundation


// MARK: - CurrencyService

class CurrencyService {

    // Shared instance to access the currency service
    static let shared = CurrencyService()

    private let fixerURL = "http://data.fixer.io/api/latest?access_key=cc89c4f40c2c113c0da814bb55266f16&symbols=USD,EUR&format=1"

    // Method to fetch the latest currency rates from the API
    func getCurrencyRates(completionHandler: @escaping ([CurrencyResponse]) -> Void) {
        // Create a URL from the fixer API endpoint
        guard let url = URL(string: fixerURL) else {
            completionHandler([])
            return
        }

        // Create a URLSession to make the network request
        let session = URLSession.shared

        // Create a data task to fetch the currency data
        let task = session.dataTask(with: url) { data, response, error in

            // Check for errors
            if let error = error {
                print("Error fetching currency rates: \(error)")
                completionHandler([])
                return
            }

            // Check if the response data is valid
            guard let data = data else {
                print("No data received from currency API")
                completionHandler([])
                return
            }

            // Decode the JSON data into CurrencyResponse objects
            let decoder = JSONDecoder()
            do {
                let currencyResponses = try decoder.decode([CurrencyResponse].self, from: data)
                completionHandler(currencyResponses)
            } catch {
                print("Error decoding currency data: \(error)")
                completionHandler([])
            }
        }
        task.resume()
    }
}
