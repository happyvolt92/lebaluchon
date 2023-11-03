import UIKit

class CurrencyViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var dollarsTextField: UITextField!
    @IBOutlet weak var eurosTextField: UITextField!
    
    @IBOutlet weak var currencyActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // When the view loads, we want to fetch the latest exchange rate and store it in UserDefaults.
        loadCurrencyRate()
    }

    // MARK: - Actions

    @IBAction func convertButtonTapped(_ sender: UIButton) {

        // Check which text field is currently active (has user input focus).
        if dollarsTextField.isFirstResponder {

            // If the 'Dollars' text field is active, we want to convert from Dollars to Euros.

            // First, we need to check if the user has entered a valid amount in the 'Dollars' text field.
            if let dollars = Double(dollarsTextField.text ?? "") {

                // Now, let's retrieve the currency conversion rate from UserDefaults.
                let usdToEuroRate = UserDefaults.standard.double(forKey: "USDToEuroRate")

                // Perform the conversion using the stored rate.
                let euros = dollars * usdToEuroRate

                // Update the 'Euros' text field with the converted amount.
                eurosTextField.text = String(format: "%.2f", euros)
            }
        } else if eurosTextField.isFirstResponder {

            // If the 'Euros' text field is active, we want to convert from Euros to Dollars.

            // Similar to the previous case, we need to check if the user entered a valid amount in the 'Euros' text field.
            if let euros = Double(eurosTextField.text ?? "") {

                // Retrieve the currency conversion rate from UserDefaults.
                let usdToEuroRate = UserDefaults.standard.double(forKey: "USDToEuroRate")

                // Perform the reverse conversion using the stored rate.
                let dollars = euros / usdToEuroRate

                // Update the 'Dollars' text field with the converted amount.
                dollarsTextField.text = String(format: "%.2f", dollars)
            }
        }
    }

    // MARK: - Currency Rate Loading

    private func loadCurrencyRate() {
        // This function is responsible for fetching the latest currency rate from a service and storing it in UserDefaults.
        CurrencyService.shared.getCurrencyRate(to: "EUR", from: "USD", amount: 100) { result in
            switch result {
            case .success(let convertedValue):
                // Handle the converted value here
                print("Converted value: \(convertedValue)")
            case .failure(let error):
                // Handle the error here
                print("Error: \(error.localizedDescription)")
            }
        }
    }


    // MARK: - Error Handling

    private func errorAlert() {
        // This function presents an error alert if there's an issue with fetching the currency rate.
        let alert = UIAlertController(title: "Error", message: "Failed to fetch currency rate.", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }
}
