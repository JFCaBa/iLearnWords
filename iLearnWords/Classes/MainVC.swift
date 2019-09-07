//
//  ViewController.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 01/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import MKProgress
import CoreData

class MainVC: UIViewController, TalkerDelegate, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnPlayOutlet: UIButton!
    //MARK: - Ivars
    var dataObj: Array<Words> = []
    let original = UserDefaults.standard.value(forKey: "TALK_LANGUAGE") ?? "ru_RU"
    let translated = NSLocale.current.languageCode ?? "en_GB"
    var talkIndex = 0
    var isOriginal = false
    var repeatCounter = 1
    //MARK: - Object instances
    let network = NetworkController()
    private var talk: TalkController = TalkController()
    private let dao: DAOController = DAOController()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        if let proxyArray = dao.fetchLastHistory() {
            dataObj = proxyArray
        }
        else{
            print("No history available")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = (UserDefaults.standard.value(forKey: "TRANSLATE_WAY") as! String)
        talk.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if btnPlayOutlet.titleLabel?.text == "PAUSE" {
            //btnPlayOutlet.setTitle("PLAY", for: .normal)
            btnPlayDidTap(btnPlayOutlet as Any)
        }
        talk.stopTalk()
    }
    
    //MARK: - Table view datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellMain") else {
                // Never fails:
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "CellMain")
            }
            return cell
        }()
        let word: Words = dataObj[indexPath.row]
        cell.textLabel?.text = word.original
        cell.detailTextLabel?.text = word.translated
        return cell
    }
    
    //MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = dataObj[indexPath.row] as Words
        startTalking(word.original!)
    }

    //MARK: - Actions
    @IBAction func btnSettingsDidTap(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoSettings", sender: self)
    }
    
    @IBAction func btnCardsDidTap(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoCardsGame", sender: self)
    }
    
    @IBAction func btnPasteDidTap(_ sender: Any) {
        let toPaste = UIPasteboard.general.string
        if nil != toPaste {
            if let tmpArray = toPaste?.components(separatedBy: "\n") {
                MKProgress.show()
                translateRecursive(tmpArray, index: 0)
            }
        }
    }
    
    private func translateWordRecursive(_ word: String) {
        
    }
    
    @IBAction func btnDeleteDidTap(_ sender: Any) {
        dataObj.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func btnEditDidTap(_ sender: Any) {
    }
    
    @IBAction func btnPlayDidTap(_ sender: Any) {
        
        let btn = sender as! UIButton

        if btn.titleLabel?.text == "PLAY"{
            btn.setTitle("PAUSE", for: .normal)
            
        }
        else{
            btn.setTitle("PLAY", for: .normal)
            talk.pauseTalk()
        }
    }
    
    //MARK: - Private functions
    private func translateRecursive(_ sender: Array<String>, index: Int = 0) {
        if sender.count > index {
            let wordObj = sender[index]
            if let translatedWord = dao.fetchTranslatedForWord(word: wordObj) {
                if let wordModel = self.dao.saveWordObjectFrom(original: wordObj, translated: translatedWord){
                    //Add the word to the array
                    self.dataObj.append(wordModel)
                }
                let i = index + 1
                //Call the method recursivily to translate all the words
                self.translateRecursive(sender, index: i)
            }
            else {
                network.completionBlock =  { (response, error) -> Void in
                    if nil == error {
                        if let wordModel = self.dao.saveWordObjectFrom(original: wordObj, translated: response!){
                            //Add the word to the array
                            self.dataObj.append(wordModel)
                        }
                        let i = index + 1
                        //Call the method recursivily to translate all the words
                        self.translateRecursive(sender, index: i)
                    }
                    else{
                        print(error as Any)
                    }
                }
                network.translateString(wordObj)
            }
        }
        else {
            MKProgress.hide()
            tableView.reloadData()
            if dataObj.count > 0 {
                saveHistory(dataObj)
            }
        }
    }
    
    private func startTalking(_ text: String, talkLanguage: String = "ru_RU") {
            self.talk.sayText(text, language: talkLanguage)
    }
    
    private func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}

extension MainVC {
    
    //MARK: TalkController delegate
    func didFinishTalk() {
        
            let repeatSettings = UserDefaults.standard.bool(forKey: "REPEAT_ORIGINAL")
            if !talk.isPaused{
                if isOriginal{
                    if !repeatSettings || repeatCounter == 3{
                        isOriginal = false //The nextone to be read will be the translated one
                    }
                    else {
                        repeatCounter += 1
                    }
                }
                else {
                    
                    talkIndex += 1 //Increment the index to change the row
                    isOriginal = true //The nextone to be read will be the original one
                    repeatCounter = 1;
                }
        }
        else{
            talkIndex = 0
            if UserDefaults.standard.bool(forKey: "PLAY_IN_LOOP"){
                //Repeat the list
                didFinishTalk()
            }
        }
    }
    
    //MARK: Save history
    private func saveHistory(_ data: Array<Words>) {
        let alertController = UIAlertController(title: "Save List", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter a List Name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            if let textField = alertController.textFields?[0] {
                if textField.text!.count > 0 {
                    let title = textField.text ?? "Utitlled"
                    if self.dao.saveHistory(data, title: title) {
                       print("\(title)")
                    }
                    else {
                        print("Error Saving History.")
                    }
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }
}

