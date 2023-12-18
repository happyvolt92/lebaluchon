
import UIKit

class CurrencyViewController: UIViewController {


    // MARK: - Outlets

    @IBOutlet weak var eurosTextField: UITextField!
    @IBOutlet weak var dollarsTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!


    // MARK: - Properties
    
    private var currentChangeRate: Double {
        ChangeRateData.changeRate
    }

    private var currentChangeRateDate: String {
        ChangeRateData.changeRateDate
    }

    private var currentDate: String {
        getCurrentDate()
    }


    // make textFields texts Double? :
    private var eurosCurrentValue: Double? {
        guard let eurosText = eurosTextField.text else {
            return nil
        }
        return Double(eurosText)
    }
    private var dollarsCurrentValue: Double? {
        guard let dollarsText = dollarsTextField.text else {
            return nil
        }
        return Double(dollarsText)
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)

        listenKeyboardNotifications()
    }

    // MARK: - Functions

    @IBAction func toggleConvertButton(_ sender: UIButton) {
        computeConversion()
    }

    private func computeConversion() {
        switch currencySegmentedControl.selectedSegmentIndex {
        case 0:
            updateDollarTextfield()
        case 1:
            updateEuroTextField()
        default:
            break
        }
    }


    private func updateDollarTextfield() {
        guard let value = eurosCurrentValue else {
            textFieldAlert()
            return
        }
        dollarsTextField.text = convert(from: .euro, value: value)
    }


    private func updateEuroTextField() {
        guard let value = dollarsCurrentValue else {
            textFieldAlert()
            return
        }
        eurosTextField.text = convert(from: .dollar, value: value)
    }

    private func convert(from currency: Currency, value: Double) -> String? {
        guard currentChangeRateDate == currentDate else {
            toggleActivityIndicator(shown: true)
            obtainCurrentChangeRate()
            return nil
        }

        switch currency {
        case .euro:
            let result = value * currentChangeRate
            let resultToDisplay = String(result)
            return resultToDisplay
        case .dollar:
            let result = value / currentChangeRate
            let resultToDisplay = String(result)
            return resultToDisplay
        }
    }

    private func obtainCurrentChangeRate() {
        ChangeRateService.shared.getChangeRate { result in
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false)
                switch result {
                case .failure:
                    self.errorAlert()
                case .success(let changeRate):
             
                    ChangeRateData.changeRate = changeRate.rates.USD
                    ChangeRateData.changeRateDate = changeRate.date
                    self.computeConversion()
                }
            }
        }
    }

    private func getCurrentDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let currentDate = format.string(from: date)

        return currentDate
    }

    @IBAction func currencyDidChange(_ sender: UISegmentedControl) {
        clearTextFields()
    }

    private func clearTextFields() {
        eurosTextField.text = ""
        dollarsTextField.text = ""
    }

    // MARK: - Alerts
    
    private func errorAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Il semble que le courant passe mal avec le serveur 🔌", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }

    private func textFieldAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Il faut d'abord entrer un montant dans le champ texte correspondant pour le convertir 💵", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - UI Aspect

    private func toggleActivityIndicator(shown: Bool) {
        convertButton.isHidden = shown
        activityIndicator.isHidden = !shown
        shown ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    // MARK: - Keyboard Management

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        eurosTextField.resignFirstResponder()
        dollarsTextField.resignFirstResponder()
    }

    private func listenKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // to make the stackView go up a bit when the keyboard appears :
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    // to make the stackView go back to its original position when the keyboard disappears :
    @objc func keyboardWillHide(notification: NSNotification) {

        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }

}
