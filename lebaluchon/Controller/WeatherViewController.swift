import Foundation
import UIKit

class WeatherViewController : UIViewController {
    // Outlets
    @IBOutlet weak var weatherInformationForeign: UITextView!
    @IBOutlet weak var cityDestinationChoiceInput: UITextField!
    @IBOutlet weak var weatherImageInformationForeign: UIImageView!
    @IBOutlet weak var weatherImageInformationHome: UIImageView!
    @IBOutlet weak var cityHomeChoiceInput: UITextField!
    @IBOutlet weak var weatherInformationHome: UITextView!
    @IBOutlet weak var saveLocationAsHomeButton: UIButton!
    @IBOutlet weak var citySearchTableView: UITableView!
    
    var matchingCities: [City] = []
    private var selectedCity: City? // To store the selected city
    var isDestinationInput: Bool = true
    
    // Action to save the selected city as the home location
    @IBAction func saveLocationAsHome(_ sender: UIButton) {
        guard let selectedCity = selectedCity else {
            // Handle the case when no city is selected
            return
        }
        
        // Encode the selected city and save it to UserDefaults
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
        
        // Add target actions for text fields to perform city search
        cityDestinationChoiceInput.addTarget(self, action: #selector(destinationCityTextChanged(_:)), for: .editingChanged)
        cityHomeChoiceInput.addTarget(self, action: #selector(homeCityTextChanged(_:)), for: .editingChanged)
        
        // Set the data source and delegate for the UITableView
        citySearchTableView.dataSource = self
        citySearchTableView.delegate = self
    }

    // Action to refresh weather data
    @IBAction func refreshWeatherButton(_ sender: Any) {
        // Call the `fetchWeather` method to refresh the weather data
        WeatherServices.shared.fetchWeather(for: selectedCity?.name ?? "defaultCity") { result in
            switch result {
                case .success(let weatherResponse):
                    // Handle the success and update your UI with the refreshed weather data
                    print("Refreshed weather data: \(weatherResponse)")
                case .failure(let error):
                    // Handle any errors that may occur during the refresh
                    print("Refresh failed with error: \(error)")
            }
        }
    }

    private var citySearchTimer: Timer?
    
    // Function to handle user input in the destination city text field
    @objc func destinationCityTextChanged(_ textField: UITextField) {
        startCitySearchTimer(isDestination: true)
    }

    // Function to handle user input in the home city text field
    @objc func homeCityTextChanged(_ textField: UITextField) {
        startCitySearchTimer(isDestination: false)
    }

    private func startCitySearchTimer(isDestination: Bool) {
        // Invalidate the existing timer when the user continues typing
        citySearchTimer?.invalidate()
        
        // Start a new timer to perform the city search after a brief delay
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
                    self.updateMatchingCities(cityList)
                case .failure(let error):
                    print("City Search Error: \(error)")
                }
            }
        }

    // Function to update the list of matching cities
    private func updateMatchingCities(_ cities: [City]) {
        matchingCities = cities
        citySearchTableView.reloadData() // Refresh the UITableView
    }
}

// Conform to UITableViewDataSource and UITableViewDelegate
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        let city = matchingCities[indexPath.row]
        cell.textLabel?.text = city.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle the selection of a city from the list
        selectedCity = matchingCities[indexPath.row]
        // You can update the selectedCity property or perform any other action here
    }
}
