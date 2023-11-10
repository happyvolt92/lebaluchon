import UIKit

class TranslatorViewController: UIViewController, UITextViewDelegate {
    // Outlets
    @IBOutlet var TranslatorView: UIView!
    @IBOutlet weak var TextViewToTranslate: UITextView!
    @IBOutlet weak var ToggleLanguages: UISegmentedControl!
    @IBOutlet weak var TranslateButton: UIButton!
    @IBOutlet weak var TextDestinationViewTranslated: UITextView!
    @IBOutlet weak var translatorActivityIndicator: UIActivityIndicatorView!

    private var translatedText = ""

    // Action when the translation button is toggled
    @IBAction func toggleTranslationButton(_ sender: UIButton) {
        // Check if the text view to translate is not empty
        guard !TextViewToTranslate.text.isEmpty else {
            showAlert(for: .apiError) // Show an alert if there's no text to translate
            return
        }

        // Start the activity indicator animation and initiate the translation
        ActivityIndicatorAnimation.shared.startLoading(for: translatorActivityIndicator)
        translate()
    }

    // Action to dismiss the keyboard
    @IBAction func dismissKeyboard(_ sender: Any) {
        TextViewToTranslate.resignFirstResponder()
    }

    // Function to perform the translation
    private func translate() {
        // Determine the target language based on the selected segment in the language toggle
        guard let language = switchLanguage() else {
            return
        }

        // Call the translation service
        TranslatorService.shared.getTextTranslation(textToTranslate: TextViewToTranslate.text, from: language) { result in
            DispatchQueue.main.async {
                // Stop the activity indicator animation when the translation is complete

                ActivityIndicatorAnimation.shared.stopLoading(for: self.translatorActivityIndicator)

                switch result {
                case .failure:
                    self.showAlert(for: .apiError) // Show an alert for translation failure
                case .success(let traductor):
                    // Update the translated text and display it in the destination text view
                    self.translatedText = traductor.data.translations.first?.translatedText ?? ""
                    self.updateTextView()
                }
            }
        }
    }

    // Function to switch the target language based on the selected segment
    private func switchLanguage() -> LanguagesOptions? {
        switch ToggleLanguages.selectedSegmentIndex {
        case 0:
            return .french
        case 1:
            return .english
        default:
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the delegate for the text view
        TextViewToTranslate.delegate = self
    }

    // Delegate method called when the text view begins editing
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
    }

    // Function to update the destination text view with the translated text
    private func updateTextView() {
        DispatchQueue.main.async {
            self.TextDestinationViewTranslated.text = self.translatedText
        }
    }
}
