import UIKit

class CurrencyViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var dollarsTextField: UITextField!
    @IBOutlet weak var eurosTextField: UITextField!
    
    @IBOutlet weak var currencyActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the activity indicator to be initially visible
        currencyActivityIndicator.hidesWhenStopped = true

        // When the view loads, we want to fetch the latest exchange rate and store it in UserDefaults.
        loadCurrencyRate()
    }


    // MARK: - Actions
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        // Check which text field is currently active (has user input focus).
        if dollarsTextField.isFirstResponder {
            if let dollars = Double(dollarsTextField.text ?? "") {
                // Start the activity indicator animation
                ActivityIndicatorAnimation.shared.startLoading(for: currencyActivityIndicator)
                CurrencyService.shared.getCurrencyRate(to: "EUR", from: "USD", amount: dollars) { result in
                    DispatchQueue.main.async {
                        // Stop the activity indicator animation
                        ActivityIndicatorAnimation.shared.stopLoading(for: self.currencyActivityIndicator)

                        switch result {
                        case .success(let convertedValue):
                            // Handle the converted value here
                            self.eurosTextField.text = String(format: "%.2f", convertedValue)
                        case .failure(let error):
                            // Handle the error here
                            self.errorAlert()
                        }
                    }
                }
            }
        } else if eurosTextField.isFirstResponder {
            if let euros = Double(eurosTextField.text ?? "") {
                // Start the activity indicator animation
                ActivityIndicatorAnimation.shared.startLoading(for: currencyActivityIndicator)
                CurrencyService.shared.getCurrencyRate(to: "USD", from: "EUR", amount: euros) { result in
                    DispatchQueue.main.async {
                        // Stop the activity indicator animation
                        ActivityIndicatorAnimation.shared.stopLoading(for: self.currencyActivityIndicator)

                        switch result {
                        case .success(let convertedValue):
                            // Handle the converted value here
                            self.dollarsTextField.text = String(format: "%.2f", convertedValue)
                        case .failure(let Apperror):
                            // Handle the error here
                            self.errorAlert()
                        }
                    }
                }
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
