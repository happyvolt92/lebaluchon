
import Foundation

class ChangeRateService {


    // MARK: - Error management

    enum ChangeRateError: Error {
        case noDataAvailable
        case parsingFailed
        case urlError
        case apiError
        case httpResponseError
    }

    // MARK: - Properties

    private(set) static var shared = ChangeRateService()

    private var task: URLSessionDataTask?
    private var session: URLSession

    private var resourceUrl: URL?
    private let apiKey = "cd00e39fcd27cab07cec878d55125e50"

    // MARK: - Init

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
        let resourceString = "http://data.fixer.io/api/latest?access_key=\(apiKey)&symbols=USD&format=1"
        self.resourceUrl = URL(string: resourceString)
    }

    // MARK: - Get Change Rate

    func getChangeRate(completion: @escaping (Result<ChangeRate, ChangeRateError>)-> Void) {
        guard let url = resourceUrl else {
            completion(.failure(.urlError))
            return
        }
        task = session.dataTask(with: url) {data, response, error in
            guard error == nil else {
                completion(.failure(.apiError))
                return
            }
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.httpResponseError))
                return
            }
            do {
                let decoder = JSONDecoder()
                let changeRate = try decoder.decode(ChangeRate.self, from: jsonData)
                completion(.success(changeRate))
            } catch {
                completion(.failure(.parsingFailed))
            }
        }
        task?.resume()
    }

}
