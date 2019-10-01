//
//  CardsGameVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 03/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit

class CardsGameVC: UIViewController {

    //Outlets
    @IBOutlet weak var lblOriginal: UILabel!
    @IBOutlet weak var lblTranslated: UILabel!
    @IBOutlet weak var btnPlayOutlet: UIButton!
    //Ivars
    private let coreDataManager: CoreDataManager = CoreDataManager()
    private var talkManager = TalkManager.shared
    /// Dependency injection ivars
    public var viewModelWords: MainWordsVM?
    public var viewModelLanguage: MainLanguageVM?
    
    var reverse: Bool = false
        
    var viewModelWord: MainWordVM?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOriginal.text = ""
        lblTranslated.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        talkManager.delegate = self
        //dataObj = (history!.words?.allObjects as! Array<Words>)
        loadAllWords()
        btnNextDidTap(UIButton())
    }
    
    //MARK: - Actions
    @IBAction func btnNextDidTap(_ sender: Any?) {
        lblTranslated.isHidden = true
        guard let original = lblOriginal.text else { return }
        guard let translated = lblTranslated.text else { return }
        
        if let count = viewModelWords?.wordsData.count {
            if count > 0 {
                if let randomElement = viewModelWords?.wordsData.randomElement()
                {
                    viewModelWord      = MainWordVM(word: randomElement)
                    lblOriginal.text   = reverse ? viewModelWord!.textTranslated : viewModelWord!.textOriginal
                    lblTranslated.text = reverse ? viewModelWord!.textOriginal :  viewModelWord!.textTranslated
                }
            }
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
        guard let langOriginal = viewModelLanguage?.sayOriginal, let langTranslated = viewModelLanguage?.sayTranslated else { return }
        
        let btn = sender as? UIButton
        btn?.isEnabled = false
        guard  let txt = reverse ? lblTranslated.text : lblOriginal.text else {
            return
        }
        talkManager.sayText(text: txt, language: reverse ? langTranslated : langOriginal)
    }
    
    @IBAction func btnReverseDidTap(_ sender: Any) {
        reverse = !reverse
        btnNextDidTap(nil)
    }
    
    @IBAction func btnAllDidTap(_ sender: Any) {
        loadAllWords()
    }
}

extension CardsGameVC: TalkerDelegate {

    //MARK: TalkController delegate
    func didFinishTalk() {
       btnPlayOutlet?.isEnabled = true
    }
}

extension CardsGameVC {
    func loadAllWords() {

    }
}
