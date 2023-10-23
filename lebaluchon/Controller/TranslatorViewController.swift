import UIKit
import NaturalLanguage

class TranslatorViewController: UIViewController, UITextViewDelegate {

    // MARK: - Outlets

    @IBOutlet var TranslatorView: UIView!
    @IBOutlet weak var TextViewTranslator: UITextView!
    @IBOutlet weak var ToggleLanguages: UISegmentedControl!
    @IBOutlet weak var TranslateButton: UIButton!
    @IBOutlet weak var TextViewToTranslate: UITextView!
    @IBOutlet weak var TextDestinationViewTranslated: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var isTranslating = false

    // MARK: - Actions

    @IBAction func toggleTranslationButton(_ sender: UIButton) {
        if !isTranslating {
            // Check if the input text field is not empty
            guard !TextViewTranslator.text.isEmpty else {
                textViewAlert()
                return
            }

            isTranslating = true
            // Disable the button and show the activity indicator
            TranslateButton.isEnabled = false
            activityIndicator.startAnimating()

            // Simulate a 2-second translation delay
            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { [weak self] in
                DispatchQueue.main.async {
                    // Hide the activity indicator and enable the button
                    self?.activityIndicator.stopAnimating()
                    self?.TranslateButton.isEnabled = true
                    self?.isTranslating = false
                }

                // Detect the language of the text in TextViewTranslator
                let detectedLanguage = NLLanguageRecognizer.dominantLanguage(for: self?.TextViewTranslator.text ?? "")

                // Determine the target language based on the detected language
                let targetLanguage: LanguagesOptions
                if detectedLanguage == .english {
                    self?.ToggleLanguages.selectedSegmentIndex = 1  // Index 1 corresponds to French in the segmented control
                    targetLanguage = .french
                } else {
                    self?.ToggleLanguages.selectedSegmentIndex = 0  // Index 0 corresponds to English in the segmented control
                    targetLanguage = .english
                }
            }
        }
    }

    // Function to initiate translation
    private func translate(completion: @escaping () -> Void) {
        guard let sourceLanguage = switchLanguage(fromToggleIndex: ToggleLanguages.selectedSegmentIndex) else {
            completion()
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
                completion() // Call completion when translation is complete
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
            self.TextDestinationViewTranslated.text = text
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

        // Set the text view delegate to self
        TextViewTranslator.delegate = self
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
