//
//  ViewController.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 01/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit

class MainVC: UIViewController, TalkerDelegate, UITextViewDelegate, UIScrollViewDelegate {

    //Outlets
    @IBOutlet weak var txtWords: UITextView!
    @IBOutlet weak var txtWordsTranslated: UITextView!
    @IBOutlet weak var btnPlayOutlet: UIButton!
    //Ivars
    var wordsList: Array<String> = Array()
    var translateWordsList: Array<String> = Array()
    var strToTranslate = "" as String
    let network = NetworkController()
    var talk: TalkController = TalkController()
    private let dao: DAOController = DAOController()
    
    let original = "ru_RU"
    let translated = "en_GB"
    
    var talkIndex = 0
    var isOriginal = false
    var repeatCounter = 1

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        talk.delegate = self
        txtWords.delegate = self
        txtWordsTranslated.delegate = self
        
        if(translateWordsList.count == 0){
            wordsList = txtWords.text.components(separatedBy: "\n")
            self.translate()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if btnPlayOutlet.titleLabel?.text == "PAUSE" {
            //btnPlayOutlet.setTitle("PLAY", for: .normal)
            btnPlayDidTap(btnPlayOutlet as Any)
        }
    }

    //MARK: Actions
    @IBAction func btnSettingsDidTap(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoSettings", sender: self)
    }
    
    @IBAction func btnCardsDidTap(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoCardsGame", sender: self)
    }
    
    @IBAction func btnPasteDidTap(_ sender: Any) {
        let toPaste = UIPasteboard.general.string
        if toPaste!.count > 0 {
            txtWords.text = toPaste
            wordsList = txtWords.text.components(separatedBy: "\n")
            txtWordsTranslated.text = ""
            translate()
        }
    }
    
    
    @IBAction func btnPlayDidTap(_ sender: Any) {
        
        //Dont continue if the textView is empty of if we didnt chante the list
        if txtWords.text.count == 0{
            return
        }
        
        let btn = sender as! UIButton
        
        if(translateWordsList.count == 0){
            wordsList = txtWords.text.components(separatedBy: "\n")
            self.translate()
        }

        if btn.titleLabel?.text == "PLAY"{
            btn.setTitle("PAUSE", for: .normal)
            if talk.isPaused{
                talk.resumeTalk()
            }
            else{
                self.startTalking(self.wordsList[0])
            }
        }
        else{
            btn.setTitle("PLAY", for: .normal)
            talk.pauseTalk()
        }
    }
    
    //MARK: Private functions
    private func translate(){
        //TODO: check with the words list if we already have some of them in the db
        var knownWordsIndexes: Array<Int> = Array()
        var wordsToTranslate : Array<String> = Array()
        var wordsInDB : Array<String> = Array()
        var txt = ""
        var txtDb = ""
        for(index, element) in wordsList.enumerated(){
            let translated = dao.getTranslatedForWord(word: element)
            if nil != translated{
                knownWordsIndexes.append(index)
                wordsInDB.append(element)
                txtDb += translated!
                if index < wordsList.count - 1{
                    txtDb += "\n"
                }
            }
            else {
                txt += element
                if index < wordsList.count - 1{
                    txt += "\n"
                }
                wordsToTranslate.append(element)
            }
        }
        
//        let wordsRemainingToTranslate = wordsList
//            .enumerated()
//            .filter { !knownWordsIndexes.contains($0.offset) }
//            .map { $0.element }
        

        
        if txt.count > 0 {
            network.translateBlock =  { (response) -> Void in
                //next step
                if nil != response{
                    self.txtWordsTranslated.text = response;
                    self.translateWordsList = (response?.components(separatedBy: "\n"))!
                    
                    for (_, element) in knownWordsIndexes.enumerated(){
                        if element < wordsInDB.count {
                            self.translateWordsList.insert(wordsInDB[element], at: element)
                        }
                    }
                    
                    for (index, element) in self.translateWordsList.enumerated(){
                        let orig = wordsToTranslate[index]
                        let success = self.dao.save(original: orig , translated: element)
                        if success{
                            print("Saved \(orig) as \(element)")
                        }
                    }
                }
            }
            network.translateStringOfWords(txt)
        }
        else {
            txtWordsTranslated.text = txtDb
        }
    }
    
    private func startTalking(_ text: String){
            self.talk.sayText(text, language: self.original)
    }
    
    private func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    //MARK: TalkController delegate
    func didFinishTalk() {
        if talkIndex < wordsList.count{
            let repeatSettings = UserDefaults.standard.bool(forKey: "REPEAT_ORIGINAL")
            if !talk.isPaused{
                if isOriginal{
                    startTalking(wordsList[talkIndex])
                    if !repeatSettings || repeatCounter == 3{
                        isOriginal = false //The nextone to be read will be the translated one
                    }
                    else {
                        repeatCounter += 1
                    }
                }
                else {
                    if translateWordsList.count == 0 {
                        translateWordsList = txtWordsTranslated.text.components(separatedBy: "\n")
                    }
                    startTalking(translateWordsList[talkIndex])
                    talkIndex += 1 //Increment the index to change the row
                    isOriginal = true //The nextone to be read will be the original one
                    repeatCounter = 1;
                }
            }
        }
        else if UserDefaults.standard.bool(forKey: "PLAY_IN_LOOP"){
            talkIndex = 0
            //Repeat the list
            didFinishTalk()
        }
    }
    
    //MARK: UITextView delegate
    func textViewDidChange(_ textView: UITextView) {
        wordsList.removeAll()
        translateWordsList.removeAll()
    }
}

extension MainVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == txtWords {
            self.synchronizeScrollView(txtWordsTranslated, toScrollView: txtWords)
        }
        else if scrollView == txtWordsTranslated {
            self.synchronizeScrollView(txtWords, toScrollView: txtWordsTranslated)
        }
    }
    
    func synchronizeScrollView(_ scrollViewToScroll: UIScrollView, toScrollView scrolledView: UIScrollView) {
        var offset = scrollViewToScroll.contentOffset
        offset.y = scrolledView.contentOffset.y
        
        scrollViewToScroll.setContentOffset(offset, animated: false)
    }
}

