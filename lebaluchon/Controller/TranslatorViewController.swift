import UIKit

class TranslatorViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var TranslatorView: UIView!
    @IBOutlet weak var TextViewToTranslate: UITextView!
    @IBOutlet weak var ToggleLanguages: UISegmentedControl!
    @IBOutlet weak var TranslateButton: UIButton!
    @IBOutlet weak var TextDestinationViewTranslated: UITextView!

    private var translatedText = ""

    // MARK: - Actions
    @IBAction func toggleTranslationButton(_ sender: UIButton) {
        guard !TextViewToTranslate.text.isEmpty else {
            textViewAlert()
            return
        }

        translate()
    }

    private func translate() {
        guard let language = switchLanguage() else {
            return
        }

        TranslatorService.shared.getTextTranslation(textToTranslate: TextViewToTranslate.text, from: language) { result in
            DispatchQueue.main.async {
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

    // Function to determine the selected language based on the segmented control
    private func switchLanguage() -> LanguagesOptions? {
        switch ToggleLanguages.selectedSegmentIndex {
        case 0:
            // Return French language if the first segment is selected
            return .french
        case 1:
            // Return English language if the second segment is selected
            return .english
        default:
            // Return nil for any other segment selection
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

    // Error handler for connection error
    private func errorAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Mais qui a coupé internet 🤔 ?", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }

    // Error handler for empty text field
    private func textViewAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Rien + Rien = Rien ! 😱 Rajoute du texte pour voir une traduction", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }
}
