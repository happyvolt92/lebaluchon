import UIKit

class CurrencyViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var eurosTextField: UITextField!
    @IBOutlet weak var dollarsTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties

    private var currentExchangeRate: Double {
        ChangeRateData.changeRate
    }

    private var currentExchangeRateDate: String {
        ChangeRateData.changeRateDate
    }

    private var currentDate: String {
        getCurrentDate()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        listenKeyboardNotifications()
    }

    // MARK: - Functions

    @IBAction func convertButtonTapped(_ sender: UIButton) {
        convertDollarsToEuro()
    }

    private func convertDollarsToEuro() {
        guard let dollarsValue = dollarsTextField.text, let dollarsAmount = Double(dollarsValue) else {
            showAlert(message: "Invalid dollar amount")
            return
        }

        guard currentExchangeRateDate == currentDate else {
            toggleActivityIndicator(shown: true)
            fetchLatestExchangeRate()
            return
        }

        let eurosAmount = dollarsAmount / currentExchangeRate
        eurosTextField.text = String(format: "%.2f", eurosAmount)
    }

    private func fetchLatestExchangeRate() {
        ChangeRateService.shared.getChangeRate { result in
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false)
                switch result {
                case .failure:
                    self.showAlert(message: "Failed to fetch exchange rate")
                case .success(let exchangeRate):
                    ChangeRateData.changeRate = exchangeRate.rates.USD
                    ChangeRateData.changeRateDate = exchangeRate.date
                    self.convertDollarsToEuro()
                }
            }
        }
    }

    private func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func toggleActivityIndicator(shown: Bool) {
        convertButton.isHidden = shown
        activityIndicator.isHidden = !shown
        shown ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        dollarsTextField.resignFirstResponder()
    }

    private func listenKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
}
