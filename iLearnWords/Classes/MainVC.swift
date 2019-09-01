//
//  ViewController.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 01/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit

class MainVC: UIViewController, TalkerDelegate, UITextViewDelegate {

    //Outlets
    @IBOutlet weak var txtWords: UITextView!
    //Ivars
    var wordsList: Array<String> = Array()
    var translateWordsList: Array<String> = Array()
    var strToTranslate = "" as String
    let network = NetworkController()
    var talk: TalkController = TalkController()
    
    let original = "ru_RU"
    let translated = "en_GB"
    
    var talkIndex = 0
    var isOriginal = false
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        talk.delegate = self
        txtWords.delegate = self
    }

    //MARK: Actions
    @IBAction func btnPlayDidTap(_ sender: Any) {
        
        //Dont continue if the list is empty of if we didnt chante the list
        if txtWords.text.count == 0{
            return
        }
        
        let btn = sender as! UIButton
        
        if(wordsList.count == 0){
            wordsList = txtWords.text.components(separatedBy: "\n")
            self.translate()
        }

        if btn.titleLabel?.text == "PLAY"{
            btn.setTitle("PAUSE", for: .normal)
            if talk.isPaused{
                talk.resumeTalk()
            }
        }
        else{
            btn.setTitle("PLAY", for: .normal)
            talk.pauseTalk()
        }
    }
    
    //MARK: Private functions
    private func translate(){
        network.translateBlock =  { (response) -> Void in
            //next step
            if nil != response{
                self.translateWordsList = (response?.components(separatedBy: "\n"))!
                self.startTalking(self.wordsList[0])
            }
        }
        network.translateArray(txtWords!.text)
    }
    
    private func startTalking(_ text: String){
            self.talk.sayText(text, language: self.original)
            //self.talk.sayText(self.translateWordsList[talkIndex], language: self.translated)
    }
    
    private func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    //MARK: TalkController delegate
    func didFinishTalk() {
        if talkIndex < wordsList.count{
            if !talk.isPaused{
                if isOriginal{
                    startTalking(wordsList[talkIndex])
                    isOriginal = false //The nextone to be read will be the translated one
                }
                else{
                    startTalking(translateWordsList[talkIndex])
                    talkIndex += 1 //Increment the index to change the row
                    isOriginal = true //The nextone to be read will be the original one
                }
            }
        }
        else{
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

