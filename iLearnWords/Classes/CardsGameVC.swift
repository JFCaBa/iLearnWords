//
//  CardsGameVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 03/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit

class CardsGameVC: UIViewController, TalkerDelegate {

    //Outlets
    @IBOutlet weak var lblOriginal: UILabel!
    @IBOutlet weak var lblTranslated: UILabel!
    @IBOutlet weak var btnPlayOutlet: UIButton!
    //Ivars
    private let dao: DAOController = DAOController()
    private var talk = TalkController.shared
    public var history: History?
    var dataObj: [Words] = []
    var max = 0
    var reverse: Bool = false
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOriginal.text = ""
        lblTranslated.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        talk.delegate = self
        loadData()
    }
    
    //MARK: - Actions
    @IBAction func btnNextDidTap(_ sender: Any?) {
        lblTranslated.isHidden = true
        guard let original = lblOriginal.text else { return }
        guard let translated = lblTranslated.text else { return }
        
        if nil != sender {
            let number = Int.random(in: 0 ..< max)
            let word = dataObj[number]
            
            lblOriginal.text = reverse ? word.translated : word.original
            lblTranslated.text = reverse ? word.original :  word.translated
        }
        else if reverse {
            lblOriginal.text = translated
            lblTranslated.text = original
        }
        else {
            lblTranslated.text = original
            lblOriginal.text = translated
        }
    }
    
    @IBAction func btnDiscoverDidTap(_ sender: Any) {
        lblTranslated.isHidden = false
    }
    
    @IBAction func btnPlayDidTap(_ sender: Any) {
        let btn = sender as? UIButton
        btn?.isEnabled = false
        guard  let txt = lblOriginal.text else {
            return
        }
        
        guard  let lang = reverse ? history?.talkTranslated : history?.talkOriginal else {
            return
        }
        
        talk.sayText(txt, language: lang )
    }
    
    @IBAction func btnReverseDidTap(_ sender: Any) {
        reverse = !reverse
        btnNextDidTap(nil)
    }
}

extension CardsGameVC {
    private func loadData() {
        dataObj = (history!.hasWord?.allObjects as! Array<Words>)
        max = dataObj.count - 1
        btnNextDidTap(UIButton())
    }
    
    //MARK: TalkController delegate
    func didFinishTalk() {
       btnPlayOutlet?.isEnabled = true
        
    }
}
