//
//  WeatherServicesFile.swift
//  lebaluchon
//
//  Created by Elodie Gage on 09/10/2023.
//

import Foundation

class WeatherServices {
    
    private(set) static var shared = WeatherServices()
    
    enum WeatherCallError: Error {
        case requestError       // Request error
        case noDataAvailable    // No data available
        case parsingFailed      // JSON data parsing failed
        case apiError           // API error
        case httpResponseError // HTTP response error
    }
    
    // URLSession task and session for performing HTTP requests
    private var task: URLSessionDataTask?
    private var session: URLSession

    // URL of the translation API resource and API key
    private let baseUrl: String = "https://api.openweathermap.org/data/2.5/weather/"
    private let apiKey = ""//DONT PUSH

    // Initialization of the translation service with a default URLSession session
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    // get weather same as the translator : get response then decode
    
    func getWeather(){
        
        
        
    }
    
    
}
