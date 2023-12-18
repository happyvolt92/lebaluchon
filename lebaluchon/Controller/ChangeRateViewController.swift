import Foundation
import UIKit


import UIKit

class ChangeRateViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var convertButton: UIButton!
    
    @IBOutlet weak var dollarsTextField: UITextField!
    
    @IBOutlet weak var eurosTextField: UITextField!
    
    @IBOutlet weak var currencyActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var CurrencySegmentedControl: UISegmentedControl!
    
    
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
        
    }
    
    // MARK: - Functions
    
    @IBAction func toggleConvertButton(_ sender: UIButton) {
        computeConversion()
        
        ActivityIndicatorAnimation.shared.startLoading(for: self.currencyActivityIndicator)
    }
    
    private func computeConversion() {
        switch CurrencySegmentedControl.selectedSegmentIndex {
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
            
            return
        }
        dollarsTextField.text = convert(from: .euro, value: value)
    }
    

    private func updateEuroTextField() {
        guard let value = dollarsCurrentValue else {
            return
        }
        eurosTextField.text = convert(from: .dollar, value: value)
    }
    
    private func convert(from currency: Currency, value: Double) -> String? {
        guard currentChangeRateDate == currentDate else {
            
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
            
                ActivityIndicatorAnimation.shared.startLoading(for: self.currencyActivityIndicator)
                switch result {
                case .failure:
                    self.showAlert(for: .apiError)
                case .success(let changeRate):
                    // save date and rate in ChangeRateData :
                    ChangeRateData.changeRate = changeRate.rates.USD
                    ChangeRateData.changeRateDate = changeRate.date
                    self.computeConversion()
                }
            }
        }
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let currentDate = format.string(from: date)
        return currentDate
    }
    
    // MARK: - Keyboard Management
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        eurosTextField.resignFirstResponder()
        dollarsTextField.resignFirstResponder()
    }
}
