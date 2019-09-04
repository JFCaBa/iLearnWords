//
//  CardsGameVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 03/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import CoreData

class CardsGameVC: UIViewController, TalkerDelegate {

    //Outlets
    @IBOutlet weak var lblOriginal: UILabel!
    @IBOutlet weak var lblTranslated: UILabel!
    @IBOutlet weak var btnPlayOutlet: UIButton!
    //Ivars
    private let dao: DAOController = DAOController()
    private var talk: TalkController = TalkController()
    var dataArray: [NSManagedObject] = []
    var max = 0
    let original = UserDefaults.standard.value(forKey: "TALK_LANGUAGE") ?? "ru_RU"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblOriginal.text = ""
        lblTranslated.text = ""
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        talk.delegate = self 
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
    
    @IBAction func btnPlayDidTap(_ sender: Any) {
        let btn = sender as? UIButton
        btn?.isEnabled = false
        talk.sayText(lblOriginal.text!, language: original as! String)
    }
}

extension CardsGameVC {
    private func loadData() {
        dataArray = dao.fetchAll("Translated")!
        max = dataArray.count - 1
        btnNextDidTap(nil)
    }
    
    //MARK: TalkController delegate
    func didFinishTalk() {
       btnPlayOutlet?.isEnabled = true
    }
}
