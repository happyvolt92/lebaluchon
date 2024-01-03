//
//
// ChangeRateService.swift
// Le baluchon
//
//create by Elodie GAGE 22/12/23


import Foundation

class ChangeRateService {

    // MARK: - Error Management

    // Enum to represent various errors that might occur during the change rate service operation
    enum ChangeRateError: Error {
        case noDataAvailable
        case parsingFailed
        case urlError
        case apiError
        case httpResponseError
    }

    // MARK: - Properties 

    // Singleton instance for shared access to the ChangeRateService
    private(set) static var shared = ChangeRateService()

    // URLSession components for network requests
    private var task: URLSessionDataTask?
    private var session: URLSession

    // URL and API key for accessing the exchange rate service
    private var resourceUrl: URL?
    private let apiKey = "cc89c4f40c2c113c0da814bb55266f16"

    // MARK: - Initialization

    // Initialize the ChangeRateService with a URLSession and set up the resource URL
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
        let resourceString = "http://data.fixer.io/api/latest?access_key=\(apiKey)&symbols=USD&format=1"
        self.resourceUrl = URL(string: resourceString)
    }

    // MARK: - Get Change Rate

    // Fetch the latest exchange rate from the service
    func getChangeRate(completion: @escaping (Result<ChangeRate, ChangeRateError>) -> Void) {
        // Ensure the resource URL is valid
        guard let url = resourceUrl else {
            completion(.failure(.urlError))
            return
        }
        // Create a data task to perform the network request
        task = session.dataTask(with: url) { data, response, error in
            // Check for network errors
            guard error == nil else {
                completion(.failure(.apiError))
                return
            }
            // Check if data is available
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            // Check for a successful HTTP response
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.httpResponseError))
                return
            }
            do {
                // Decode JSON data into a ChangeRate object using JSONDecoder
                let decoder = JSONDecoder()
                let changeRate = try decoder.decode(ChangeRate.self, from: jsonData)
                completion(.success(changeRate))
            } catch {
                // Handle parsing errors
                completion(.failure(.parsingFailed))
            }
        }
        // Start the data task
        task?.resume()
    }
}
