import Foundation

class TranslatorService {
    // Shared static property to access the translation service from other parts of the application
    private(set) static var shared = TranslatorService()


    // URLSession task and session for performing HTTP requests
    private var task: URLSessionDataTask?
    private var session: URLSession

    // URL of the translation API resource and API key
    private var resourceUrl: URL?
    private let apiKey = "AIzaSyCZx6qq5FD2d0wWX6fw7s0ALTGbNaPgISs"

    // Initialization of the translation service with a default URLSession session
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
        let resourceString = "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)"
        self.resourceUrl = URL(string: resourceString)
    }
    
    // Function to obtain a translation
    func getTextTranslation(textToTranslate: String?, from language: LanguagesOptions, completion: @escaping(Result<TranslationData, AppError>) -> Void) {
        // Check if a valid URLRequest can be created for the translation request
        guard let request = createTranslationRequest(textToTranslate: textToTranslate, from: language) else {
            // If request creation fails, report a request error and return early
            completion(.failure(.requestError))
            return
        }

        // Create a URLSession data task to perform the translation request
        task = session.dataTask(with: request) { data, response, error in
            // Check for errors during the task
            DispatchQueue.main.async {
                guard error == nil else {
                    // If there is an error during the task, report an API error and return early
                    completion(.failure(.apiError))
                    return
                }
                // Check if there is data available in the response
                guard let jsonData = data else {
                    // If no data is available, report no data available and return early
                    completion(.failure(.noDataAvailable))
                    return
                }
                // Check if the HTTP response status code is 200 (OK)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    // If the HTTP response is not valid, report an HTTP response error and return early
                    completion(.failure(.httpResponseError))
                    return
                }
                do {
                    // Use a JSON decoder to parse JSON data into a TranslationData structure
                    let decoder = JSONDecoder()
                    let traductor = try decoder.decode(TranslationData.self, from: jsonData)
                    
                    // If parsing is successful, report the translation data as a success result
                    completion(.success(traductor))
                } catch {
                    // If parsing fails, report a parsing error
                    completion(.failure(.parsingFailed))
                }
            }
        }
        // Start the data task to perform the translation request
        task?.resume()
    }

    private func createTranslationRequest(textToTranslate: String?, from language: LanguagesOptions) -> URLRequest? {
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
