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
    var dataArray: [Words] = []
    var max = 0
    let original = UserDefaults.standard.value(forKey: UserDefaults.keys.TalkOriginal) ?? "ru_RU"
    
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
        let word = dataArray[number] 
        lblOriginal.text = word.original
        lblTranslated.text = word.translated
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
        dataArray = dao.fetchCards() ?? []
        max = dataArray.count - 1
        btnNextDidTap(nil)
    }
    
    //MARK: TalkController delegate
    func didFinishTalk() {
       btnPlayOutlet?.isEnabled = true
    }
}
