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
    
    
    private func createTranslationRequest(textToTranslate: String?, from language: Language) -> URLRequest? {
        guard let url = resourceUrl, let text = textToTranslate else {
            return nil
        }
        // Determine the source and target languages based on the selected language.
        let sourceLanguage = language == .english ? "en" : "fr"
        let targetLanguage = language == .english ? "fr" : "en"
        
        // Create the request body with the specified parameters.
        let body = "q=\(text)&source=\(sourceLanguage)&target=\(targetLanguage)&format=text"
        
        // Create and configure a URLRequest with the constructed URL and body.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        
        return request
    }

  
}
