//
//  TranslatorViewController.swift
//  lebaluchon
//
//  Created by Elodie Gage on 26/09/2023.
//

import Foundation
import UIKit


class TranslatorViewController : UIViewController {
    
    
    @IBOutlet var TranslatorView: UIView!
    
    @IBOutlet weak var TextViewTranslator: UITextView!
    
    @IBOutlet weak var ToggleLanguages: UISegmentedControl!
    
    @IBOutlet weak var TranslateButton: UIButton!
    
    private var translatedText = ""

    private func switchLanguage() -> Language? {
        switch ToggleLanguages.selectedSegmentIndex {
        case 0 :
            return .french
        case 1 :
            return .english
        default :
            return nil
        }
    }
    
//    ERROR Handler
    //no connection error
    private func errorAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Mais qui a coupé internet 🤔 ?", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }
    //no word to translate error
    private func textViewAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Rien + Rien = Rien !😱 Rajoute du texte pour voir une traduction", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func updateTextView() {
           DispatchQueue.main.async {
               // Update the text view with the translated text
               self.TextViewTranslator.text = self.translatedText
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
}
