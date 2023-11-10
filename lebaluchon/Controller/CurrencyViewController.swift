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
                            // Update the euros text field with the converted value
                            self.eurosTextField.text = String(format: "%.2f", convertedValue)
                        case .failure(let error):
                            // Show an alert for the currency conversion failure using error.swift
                            if let appError = error as? AppError {
                                self.showAlert(for: appError)
                            } else {
                                print("Unexpected error type")
                            }
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
                            // Update the dollars text field with the converted value
                            self.dollarsTextField.text = String(format: "%.2f", convertedValue)
                        case .failure(let error):
                            // Show an alert for the currency conversion failure using error.swift
                            if let appError = error as? AppError {
                                self.showAlert(for: appError)
                            } else {
                                print("Unexpected error type")
                            }
                        }
                    }
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
