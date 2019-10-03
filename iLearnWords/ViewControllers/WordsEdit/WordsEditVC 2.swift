//
//  WordsEditVCViewController.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 07/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit

class WordsEditVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var txtOriginal: UITextView!
    @IBOutlet weak var txtTranslated: UITextView!
    // MARK: - Object instances
    private let coreDataManager: CoreDataManager = CoreDataManager()
    // MARK: - View Models
    public var viewModelWord: MainWordVM? 
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtOriginal.text = viewModelWord?.originalWord
        txtTranslated.text = viewModelWord?.translatedWord
    }

    // MARK: - Actions
    @IBAction func btnSaveDidTap(_ sender: Any) {
        guard let _ = txtOriginal.text,  let _ = txtTranslated.text else { return }
        if coreDataManager.updateWord(original: txtOriginal.text, translated: txtTranslated.text) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
