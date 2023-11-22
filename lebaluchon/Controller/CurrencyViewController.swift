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

        // When the view loads, fetch the latest exchange rate and store it in UserDefaults
        loadCurrencyRate()
    }

    @IBAction func convertButtonTapped(_ sender: UIButton) {
        guard let amountText = dollarsTextField.text, let amount = Double(amountText) else {
            showAlert(title: "Invalid Amount", message: "Please enter a valid amount.")
            return
        }

        let fromCurrency = dollarsTextField.isFirstResponder ? "USD" : "EUR"
        let toCurrency = dollarsTextField.isFirstResponder ? "EUR" : "USD"

        ActivityIndicatorAnimation.shared.startLoading(for: currencyActivityIndicator)
        CurrencyConverter.convertCurrency(amount: amount, fromCurrency: fromCurrency, toCurrency: toCurrency) { result in
            DispatchQueue.main.async {
                ActivityIndicatorAnimation.shared.stopLoading(for: self.currencyActivityIndicator)

                switch result {
                case .success(let convertedValue):
                    let textField = self.dollarsTextField.isFirstResponder ? self.eurosTextField : self.dollarsTextField
                    textField?.text = String(format: "%.2f", convertedValue)

                case .failure(let error):
                    self.showAlert(for: error)
                }
            }
        }
    }

    // MARK: - Currency Rate Loading
    private func loadCurrencyRate() {
        // Fetch the latest currency rate from a service and store it in UserDefaults
        CurrencyService.shared.getCurrencyRate(to: "EUR", from: "USD", amount: 100) { result in
            switch result {
            case .success(let convertedValue):
                // Handle the converted value here
                print("Converted value: \(convertedValue)")
            case .failure(let error):
                // Show an alert for the currency rate fetching failure using error.swift
                if let appError = error as? AppError {
                    self.showAlert(for: appError)
                } else {
                    print("Unexpected error type")
                }
            }
        }
    }
}
