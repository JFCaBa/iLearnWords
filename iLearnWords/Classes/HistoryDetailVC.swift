//
//  HistoryDetailVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 05/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import CoreData

class HistoryDetailVC: UIViewController {

    @IBOutlet weak var txtText: UITextView!
    
    public var text: String?
    public var obj: NSManagedObject?
    private let dao: DAOController = DAOController()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtText?.text = text
    }
    
    //MARK: - Actions
    @IBAction func switchDidTap(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Switch to History", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Yes", style: .default, handler: { alert -> Void in
            UIPasteboard.general.string = self.text
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteDidTap(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete From History", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Yes", style: .default, handler: { alert -> Void in
            dao.
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }
}
