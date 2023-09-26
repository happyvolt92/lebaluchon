import Foundation

// TranslationData Structure for Mapping JSON Data
// This structure is designed to map JSON data received from an API response using the Codable protocol.

struct TranslationData: Codable {
    // TranslationDetails Structure
    // Represents details of the translation, including an array of translated text.
    struct TranslationDetails: Codable {
        var translations: [TranslatedText]
    }
    
    // TranslatedText Structure
    // Represents a single translated text.
    struct TranslatedText: Codable {
        var translatedText: String
    }
    
    // The top-level structure contains translation details.
    var data: TranslationDetails
}
