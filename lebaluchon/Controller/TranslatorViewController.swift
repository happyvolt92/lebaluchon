//
//  TranslatorViewController.swift
//  lebaluchon
//
//  Created by Elodie Gage on 26/09/2023.
//

import Foundation
import UIKit


class TranslatorViewController : UIViewController {
    
    
    @IBOutlet weak var InputTextFieldTranslation: UITextField!

    @IBOutlet weak var ToggleLanguages: UISegmentedControl!
    
    @IBOutlet weak var TranslateButton: UIButton!
    
    

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
}
