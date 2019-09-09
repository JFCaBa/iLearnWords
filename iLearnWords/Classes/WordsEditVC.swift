//
//  WordsEditVCViewController.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 07/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit

class WordsEditVC: UIViewController {

    @IBOutlet weak var txtOriginal: UITextView!
    @IBOutlet weak var txtTranslated: UITextView!
    
    public var dataObj: Words?
    private let dao: DAOController = DAOController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtOriginal.text = dataObj?.original
        txtTranslated.text = dataObj?.translated
    }

    @IBAction func btnSaveDidTap(_ sender: Any) {
        if dao.updateWord(original: dataObj!.original!, translated: dataObj!.translated!) {
            guard let original = txtOriginal.text else { return }
            guard let translated = txtTranslated.text else { return }
            dataObj?.original = original
            dataObj?.translated = translated
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnDeleteDidTap(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Word?", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Yes", style: .default, handler: { alert -> Void in
            if self.dao.deleteObject(self.dataObj!) {
                print("Word deleted")
                self.navigationController?.popViewController(animated: true)
            }
            else {
                print("Error deleting Word")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }
}
