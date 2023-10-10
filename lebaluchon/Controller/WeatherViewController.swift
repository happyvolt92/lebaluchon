//
//  WeatherViewController.swift
//  lebaluchon
//
//  Created by Elodie Gage on 29/09/2023.
//



import Foundation
import UIKit

class WeatherViewController : UIViewController {
    // outlets
    
    
@IBOutlet weak var weatherInformationForeign: UITextView!
    
    @IBOutlet weak var cityDestinationChoiceInput: UITextField!
    
    @IBOutlet weak var weatherImageInformationForeign: UIImageView!
    
    @IBOutlet weak var weatherImageInformationHome: UIImageView!
    
    @IBOutlet weak var cityHomeChoiceInput: UITextField!
    
    @IBOutlet weak var weatherInformationHome: UITextView!
    
    @IBOutlet weak var saveLocationAsHomeButton: UIButton!
    
    private var selectedCity: City? // To store the selected city
    var isDestinationInput: Bool = true
    
    @IBAction func saveLocationAsHome(_ sender: UIButton) {
         guard let selectedCity = selectedCity else {
             // Handle the case when no city is selected
             return
         }
        let encoder = JSONEncoder()
              if let encodedData = try? encoder.encode(selectedCity) {
                  UserDefaults.standard.set(encodedData, forKey: "homeCity")
              }
        // Show a confirmation message to the user
        let alertController = UIAlertController(title: "Saved as Home", message: "The selected city has been saved as your home location.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Add target actions for text fields
        cityDestinationChoiceInput.addTarget(self, action: #selector(destinationCityTextChanged(_:)), for: .editingChanged)
        cityHomeChoiceInput.addTarget(self, action: #selector(homeCityTextChanged(_:)), for: .editingChanged)
    }

    @objc func destinationCityTextChanged(_ textField: UITextField) {
        startCitySearchTimer(isDestination: true)
    }

    @objc func homeCityTextChanged(_ textField: UITextField) {
        startCitySearchTimer(isDestination: false)
    }

    private var citySearchTimer: Timer?

    private func startCitySearchTimer(isDestination: Bool) {
        // Invalidate the existing timer (if any) when the user continues typing
        citySearchTimer?.invalidate()

        // Start a new timer to perform the city search after a brief delay (e.g., 1 second)
        citySearchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] timer in
            guard let self = self else { return }
            if isDestination {
                self.performCitySearch(cityName: self.cityDestinationChoiceInput.text, isDestination: true)
            } else {
                self.performCitySearch(cityName: self.cityHomeChoiceInput.text, isDestination: false)
            }
        }
    }

    private func performCitySearch(cityName: String?, isDestination: Bool) {
        WeatherServices.shared.performCitySearch(cityName: cityName ?? "") { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let cityList):
                // Handle the list of matching cities here
                // You can display the list to the user or let them choose one
                print("Matching cities: \(cityList)")
            case .failure(let error):
                print("City Search Error: \(error)")
            }
        }
    }
}
