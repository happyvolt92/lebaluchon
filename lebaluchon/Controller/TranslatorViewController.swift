import Foundation
import UIKit

class TranslatorViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var TranslatorView: UIView!
    @IBOutlet weak var TextViewTranslator: UITextView!
    @IBOutlet weak var ToggleLanguages: UISegmentedControl!
    @IBOutlet weak var TranslateButton: UIButton!
    
    @IBOutlet weak var TextViewToTranslate: UITextView! // First translation field
    @IBOutlet weak var TextDestinationViewTranslated: UITextView! // Second translation field
    
    // MARK: - Actions
    
    @IBAction func toggleTranslationButton(_ sender: UIButton) {
        // Check if the input text field is not empty
        guard !TextViewTranslator.text.isEmpty else {
            textViewAlert()
            return
        }
        translate()
    }

    // Function to initiate translation
    private func translate() {
        guard let sourceLanguage = switchLanguage(fromToggleIndex: ToggleLanguages.selectedSegmentIndex) else {
            return
        }
        
        // Determine the target language based on the source language
        let targetLanguage: LanguagesOptions = sourceLanguage == .english ? .french : .english
        
        TranslatorService.shared.getTextTranslation(textToTranslate: TextViewTranslator.text, from: sourceLanguage) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    self.errorAlert()
                case .success(let translator):
                    if let translatedText = translator.data.translations.first?.translatedText {
                        // Update the appropriate text field with the translation
                        self.updateTextView(for: targetLanguage, with: translatedText)
                    }
                }
            }
        }
    }
    
    // Function to determine the language selected based on the segmented control index
    private func switchLanguage(fromToggleIndex index: Int) -> LanguagesOptions? {
        return index == 0 ? .english : .french
    }
    
    // Function to update the appropriate text field with the translation
    private func updateTextView(for language: LanguagesOptions, with text: String) {
        DispatchQueue.main.async {
            if language == .english {
                self.TextViewToTranslate.text = text
            } else {
                self.TextDestinationViewTranslated.text = text
            }
        }
    }
    
    // MARK: - Text View Delegate

       func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
           // Make the text view the first responder to show the keyboard
           textView.becomeFirstResponder()
           return true
       }
       
       func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
           // Dismiss the keyboard when the user is done editing
           textView.resignFirstResponder()
           return true
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Error handler for connection error
    private func errorAlert() {
        let alert = UIAlertController(title: "Error", message: "Internet connection lost 🤔", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }

    // Error handler for empty text field
    private func textViewAlert() {
        let alert = UIAlertController(title: "Error", message: "Nothing + Nothing = Nothing! 😱 Add some text to see a translation", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }
}
