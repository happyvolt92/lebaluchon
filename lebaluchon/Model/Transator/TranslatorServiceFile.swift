import Foundation

class TraductorService {

    // Enumeration to handle translation service-related errors
    enum TraductorError: Error {
        case requestError       // Request error
        case noDataAvailable    // No data available
        case parsingFailed      // JSON data parsing failed
        case apiError           // API error
        case httpResponseError // HTTP response error
    }
    
    // Shared static property to access the translation service from other parts of the application
    private(set) static var shared = TraductorService()

    // URLSession task and session for performing HTTP requests
    private var task: URLSessionDataTask?
    private var session: URLSession

    // URL of the translation API resource and API key
    private var resourceUrl: URL?
    private let apiKey = "API_KEY"

    // Initialization of the translation service with a default URLSession session
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
        let resourceString = "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)"
        self.resourceUrl = URL(string: resourceString)
    }

  
}
