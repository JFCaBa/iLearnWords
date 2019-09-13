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
        dataObj = (history!.words?.allObjects as! Array<Words>)
        btnNextDidTap(UIButton())
    }
    
    //MARK: - Actions
    @IBAction func btnNextDidTap(_ sender: Any?) {
        lblTranslated.isHidden = true
        guard let original = lblOriginal.text else { return }
        guard let translated = lblTranslated.text else { return }
        
        if dataObj.count > 0 {
            let randomWord = dataObj.randomElement()
            lblOriginal.text = reverse ? randomWord!.translated : randomWord!.original
            lblTranslated.text = reverse ? randomWord!.original :  randomWord!.translated
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
        
        let language = dao.fetchSelectedLanguage()
        guard  let lang = reverse ? language?.sayTranslate : language?.sayOriginal else {
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

    //MARK: TalkController delegate
    func didFinishTalk() {
       btnPlayOutlet?.isEnabled = true
        
    }
}
