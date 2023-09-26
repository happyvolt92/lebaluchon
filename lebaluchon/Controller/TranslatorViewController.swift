//
//  TranslatorViewController.swift
//  lebaluchon
//
//  Created by Elodie Gage on 26/09/2023.
//

import Foundation
import UIKit


class TranslatorViewController : UIViewController {
    
    @IBOutlet weak var OriginLanguagePickerView: UIPickerView!
    
    @IBOutlet weak var InputTextFieldTranslation: UITextField!

    @IBOutlet weak var DestinationLanguagePickerView: UIPickerView!
    
    @IBOutlet weak var OutputTextFieldTranslation: UITextField!
    
    @IBOutlet weak var TranslateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
}
