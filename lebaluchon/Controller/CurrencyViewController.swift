import Foundation
import UIKit

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var dollarsTextField: UITextField!
    @IBOutlet weak var eurosTextField: UITextField!
    @IBOutlet weak var currencyActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the activity indicator to be initially visible
        currencyActivityIndicator.hidesWhenStopped = true
        // Load the latest currency rates when the view loads
        loadCurrencyRate()
    }

    @IBAction func convertButtonTapped(_ sender: UIButton) {
        // Start the activity indicator to indicate that data is being fetched
        currencyActivityIndicator.startAnimating()

        // Check if the dollarTextField is empty
        guard let dollarsString = dollarsTextField.text, !dollarsString.isEmpty else {
            showErrorToUser("Please enter a digit in the USD field")
            currencyActivityIndicator.stopAnimating()
            return
        }

        // Convert the dollars to euros using the CurrencyConverter
        let dollars = Double(dollarsString)!
        let currencyConverter = CurrencyConverter(currencyRate: getCurrencyRate())
        let euros = currencyConverter.convertUSDToEUR(amount: dollars)

        // Format the converted euros value with the correct currency code
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")

        let formattedEuros = numberFormatter.string(from: euros as NSNumber)

        // Update the eurosTextField with the formatted amount
        eurosTextField.text = formattedEuros

        // Stop the activity indicator once the conversion is done
        currencyActivityIndicator.stopAnimating()
    }

    @IBAction func loadCurrencyRate() {
        // Create an instance of CurrencyService
        let currencyService = CurrencyService()

        // Fetch the latest currency rates from the API with the services
        currencyService.getCurrencyRates { currencyResponses in
            // Parse and process the currency responses
            if let currencyResponse = currencyResponses.first {
                // Extract the exchange rate
                let currencyRate = currencyResponse.rates.eur

                // Set the currency rate
                self.setCurrencyRate(currencyRate: Double(currencyRate))
            } else {
                // Handle no currency data error
                print("Failed to fetch currency rates")
            }
        }
    }

    private func setCurrencyRate(currencyRate: Double) {
        // Store the currency rate
        _currencyRate = currencyRate
    }

    private func getCurrencyRate() -> Double {
        return _currencyRate ?? 0.0
    }

    private func showErrorToUser(_ errorText: String) {
        let alertController = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }

    private var _currencyRate: Double?
}
