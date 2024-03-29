//
//  CardsGameVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 03/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit

class CardsGameVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblOriginal: UILabel!
    @IBOutlet weak var lblTranslated: UILabel!
    @IBOutlet weak var btnPlayOutlet: UIButton!
    // MARK: - Objects
    private let coreDataManager: CoreDataManager = CoreDataManager()
    private var talkManager = TalkManager.shared
    // MARK: -  Dependency injection objects
    public var viewModelWords: MainWordsVM? {
        didSet {
            btnNextDidTap(nil)
        }
    }
    public var viewModelLanguage: MainLanguageVM?
    // MARK: - ViewModels
    var viewModelWord: MainWordVM?
    // MARK: - Ivars
    var reverse: Bool = false
    
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
        guard let _ = lblTranslated?.text else { return }
        lblTranslated.isHidden = true
        if let count = viewModelWords?.numberOfWords {
            if count > 0 {
                if let randomElement = viewModelWords?.wordsData.randomElement()
                {
                    viewModelWord      = MainWordVM(word: randomElement)
                    lblOriginal.text   = reverse ? viewModelWord!.textTranslated : viewModelWord!.textOriginal
                    lblTranslated.text = reverse ? viewModelWord!.textOriginal :  viewModelWord!.textTranslated
                }
            }
        }
    }
    
    @IBAction func btnDiscoverDidTap(_ sender: Any) {
        lblTranslated.isHidden = false
    }
    
    @IBAction func btnPlayDidTap(_ sender: Any) {
        guard let langOriginal = viewModelLanguage?.sayOriginal, let langTranslated = viewModelLanguage?.sayTranslated else { return }
        guard  let txt = reverse ? lblTranslated.text : lblOriginal.text else { return }
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

// MARK: - TalkManager Delegate
extension CardsGameVC: TalkerDelegate {

    //MARK: TalkController delegate
    func didFinishTalk() {
       btnPlayOutlet?.isEnabled = true
    }
}

// MARK: - Load data extension
extension CardsGameVC {
    func loadAllWords() {
        if let words = coreDataManager.fetchAllByEntity(UserDefaults.Entity.Words) as? [Words] {
            viewModelWords = MainWordsVM(wordsData: words)
        }
    }
}
