//
//  CardsGameVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 03/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import CoreData

class CardsGameVC: UIViewController {

    //Outlets
    @IBOutlet weak var lblOriginal: UILabel!
    @IBOutlet weak var lblTranslated: UILabel!
    
    //Ivars
    private let dao: DAOController = DAOController()
    var dataArray: [NSManagedObject] = []
    var max = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblOriginal.text = ""
        lblTranslated.text = ""
        
        loadData()
    }
    
    //MARK: - Actions
    @IBAction func btnNextDidTap(_ sender: Any?) {
        lblTranslated.isHidden = true
        
        let number = Int.random(in: 0 ..< max)
        let obj = dataArray[number]
        
        lblOriginal.text = obj.value(forKey: "original") as? String
        lblTranslated.text = obj.value(forKey: "trans") as? String
    }
    
    @IBAction func btnDiscoverDidTap(_ sender: Any) {
        lblTranslated.isHidden = false
    }
    
}

extension CardsGameVC {
    private func loadData() {
        dataArray = dao.fetchAllWords()!
        max = dataArray.count - 1
        btnNextDidTap(nil)
    }
}
