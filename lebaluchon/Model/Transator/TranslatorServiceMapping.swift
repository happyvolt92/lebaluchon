import Foundation

// TranslationData Structure for Mapping JSON Data
// This structure is designed to map JSON data received from an API response using the Decodable protocol.

struct TranslationData: Decodable {
    // TranslationDetails Structure
    // Represents details of the translation, including an array of translated text.
    struct TranslationDetails: Decodable {
        var translations: [TranslatedText]
    }
    
    // TranslatedText Structure
    // Represents a single translated text.
    struct TranslatedText: Decodable {
        var translatedText: String
    }
    // The top-level structure contains translation details.
    var data: TranslationDetails
}
