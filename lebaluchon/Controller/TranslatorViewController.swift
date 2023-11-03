import UIKit

class TranslatorViewController: UIViewController {

    @IBOutlet var TranslatorView: UIView!
    @IBOutlet weak var TextViewToTranslate: UITextView!
    @IBOutlet weak var ToggleLanguages: UISegmentedControl!
    @IBOutlet weak var TranslateButton: UIButton!
    @IBOutlet weak var TextDestinationViewTranslated: UITextView!
    @IBOutlet weak var translatorActivityIndicator: UIActivityIndicatorView!

    private var translatedText = ""

    @IBAction func toggleTranslationButton(_ sender: UIButton) {
        guard !TextViewToTranslate.text.isEmpty else {
            textViewAlert()
            return
        }

        // Start the activity indicator animation
        ActivityIndicatorAnimation.shared.startLoading(for: translatorActivityIndicator)

        translate()
    }

    private func translate() {
        guard let language = switchLanguage() else {
            return
        }

        TranslatorService.shared.getTextTranslation(textToTranslate: TextViewToTranslate.text, from: language) { result in
            DispatchQueue.main.async {
                // Stop the activity indicator animation when the API call completes
                ActivityIndicatorAnimation.shared.stopLoading(for: self.translatorActivityIndicator)

                switch result {
                case .failure:
                    self.errorAlert()
                case .success(let traductor):
                    self.translatedText = traductor.data.translations.first?.translatedText ?? ""
                    self.updateTextView()
                }
            }
        }
    }

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
        // Do any additional setup after loading the view.
    }

    private func updateTextView() {
           DispatchQueue.main.async {
               // Update the text view with the translated text
               self.TextDestinationViewTranslated.text = self.translatedText
           }
    }

    private func errorAlert() {
        let alert = UIAlertController(title: "Error", message: "Internet connection lost 🤔", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }

    private func textViewAlert() {
        let alert = UIAlertController(title: "Error", message: "Nothing + Nothing = Nothing! 😱 Add some text to see a translation", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }
}
