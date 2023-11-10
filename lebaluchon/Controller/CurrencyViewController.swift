import UIKit

class CurrencyViewController: UIViewController {
    @IBOutlet weak var dollarsTextField: UITextField!
    @IBOutlet weak var eurosTextField: UITextField!
    @IBOutlet weak var currencyActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyActivityIndicator.hidesWhenStopped = true
        loadCurrencyRate()
    }

    @IBAction func convertButtonTapped(_ sender: UIButton) {
        if dollarsTextField.isFirstResponder {
            if let dollars = Double(dollarsTextField.text ?? "") {
                ActivityIndicatorAnimation.shared.startLoading(for: currencyActivityIndicator)
                CurrencyService.shared.getCurrencyRate(to: "EUR", from: "USD", amount: dollars) { result in
                    DispatchQueue.main.async {
                        ActivityIndicatorAnimation.shared.stopLoading(for: self.currencyActivityIndicator)
                        switch result {
                        case .success(let convertedValue):
                            self.eurosTextField.text = String(format: "%.2f", convertedValue)
                        case .failure:
                            self.showAlert(for: .requestError)
                        }
                    }
                }
            }
        } else if eurosTextField.isFirstResponder {
            if let euros = Double(eurosTextField.text ?? "") {
                ActivityIndicatorAnimation.shared.startLoading(for: currencyActivityIndicator)
                CurrencyService.shared.getCurrencyRate(to: "USD", from: "EUR", amount: euros) { result in
                    DispatchQueue.main.async {
                        ActivityIndicatorAnimation.shared.stopLoading(for: self.currencyActivityIndicator)
                        switch result {
                        case .success(let convertedValue):
                            self.dollarsTextField.text = String(format: "%.2f", convertedValue)
                        case .failure:
                            self.showAlert(for: .requestError)
                        }
                    }
                }
            }
        }
    }

    private func loadCurrencyRate() {
        CurrencyService.shared.getCurrencyRate(to: "EUR", from: "USD", amount: 100) { result in
            switch result {
            case .success(let convertedValue):
                print("Converted value: \(convertedValue)")
            case .failure:
                self.showAlert(for: .requestError)
            }
        }
    }
}
