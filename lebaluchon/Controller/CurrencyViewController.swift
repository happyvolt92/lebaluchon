//
//
// CurrencyViewController
// Le baluchon
//
//create by Elodie GAGE 22/12/23

import UIKit

class CurrencyViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var eurosTextField: UITextField!
    @IBOutlet weak var dollarsTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    // Add a property for the change rate service
    var changeRateService: ChangeRateService!
    // Properties for currency exchange rate data
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

    // Action when the convert button is tapped
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        convertDollarsToEuro()
        
    }
    // Toggle the visibility of the activity indicator and convert button
  @IBAction  func toggleActivityIndicator(shown: Bool) {
        convertButton.isHidden = shown
        activityIndicator.isHidden = !shown
        shown ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    // Convert entered dollars to euros
    func convertDollarsToEuro() {
        guard isViewLoaded else { return }  // Ensure view is loaded
        guard let dollarsTextField = dollarsTextField,
                let eurosTextField = eurosTextField else {
            print("Outlets are not connected")
            return
        }
        
        guard let dollarsValue = dollarsTextField.text,
                let dollarsAmount = Double(dollarsValue) else {
            showAlert(message: "Invalid dollar amount")
            return
        }
        // Perform the conversion
        let eurosAmount = dollarsAmount / currentExchangeRate
        eurosTextField.text = String(format: "%.2f", eurosAmount)
    }

    // Fetch the latest exchange rate
     func fetchLatestExchangeRate() {
        ChangeRateService.shared.getChangeRate { result in
            // to perform chnage on UI always on main thread
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false)
                switch result {
                case .failure:
                    self.showAlert(message: "Failed to fetch exchange rate")
                case .success(let exchangeRate):
                    // Update the exchange rate data and perform the conversion
                    ChangeRateData.changeRate = exchangeRate.rates.USD
                    ChangeRateData.changeRateDate = exchangeRate.date
                    self.convertDollarsToEuro()
                }
            }
        }
    }

    // Get the current date as a string
    private func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // Show an alert with a given message
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }



    // Dismiss the keyboard when tapping outside the text field
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        dollarsTextField.resignFirstResponder()
    }

    // Set up keyboard notification listeners for showing and hiding the keyboard
    private func listenKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Adjust the layout when the keyboard is about to show
    @objc func keyboardWillShow(notification: NSNotification) {
        guard ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil else {
            return
        }
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }

    // Reset the layout when the keyboard is about to hide
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
}
