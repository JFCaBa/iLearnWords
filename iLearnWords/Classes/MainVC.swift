//
//  ViewController.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 01/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import MKProgress

class MainVC: UIViewController, TalkerDelegate, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnPlayOutlet: UIButton!
    //MARK: - Ivars
    var dataObj: Array<Words> = []
    var history: History?
    let original = UserDefaults.standard.value(forKey: UserDefaults.keys.TalkOriginal) ?? "ru_RU"
    var talkIndex = 0
    var isOriginal = false
    var repeatCounter = 1
    //MARK: - Object instances
    let network = NetworkController()
    private var talk = TalkController.shared
    private let dao: DAOController = DAOController()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Need to load the title in viewWillAppear because it can change
        //depending on the language selection in settings
        if let language = dao.fetchSelectedByEntity(UserDefaults.Entity.Languages) {
            title = (language as! Languages).way
        }
        else {
            title = ""
        }
        //Assign the delegate in viewWillAppear because the talk class is
        //also used in the Cards game
        talk.delegate = self
        
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if talk.stopTalk() {
            btnPlayOutlet.setTitle(NSLocalizedString("PLAY", comment: ""), for: .normal)
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoCardsGame" {
            let cards = segue.destination as! CardsGameVC
            cards.history = history
        }
    }
    
    //MARK: - Table view datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObj.count
    }
    
    let bgCellSelectedColor =  UserDefaults.standard.colorForKey(key: UserDefaults.keys.CellSelectedBackgroundColor)
    let bgCellColor = UserDefaults.standard.colorForKey(key: UserDefaults.keys.CellBackgroundColor)
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
        cell.backgroundColor = bgCellColor
        return cell
    }
    
    //MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Dont play the word if we are already playing the list
        tableView.deselectRow(at: indexPath, animated: false)
        if talk.isSpeaking() {
            return
        }
        btnPlayOutlet.isEnabled = false
        let word = dataObj[indexPath.row] as Words
        isOriginal = true
        startTalking(word.original!)
    }
    
    //Set the history title as Title in the header section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let txt = history?.title {
            return txt
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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
            if var tmpArray = toPaste?.components(separatedBy: "\n") {
                MKProgress.show()
                // If when pasting the last char is \n this generate an empty string in the array, we'll remove it here
                if tmpArray.last == "" {
                    tmpArray.removeLast()
                }
                translateRecursive(tmpArray, index: 0)
            }
        }
    }
    
    @IBAction func btnDeleteDidTap(_ sender: Any) {
        dataObj.removeAll()
        history = nil
        tableView.reloadData()
    }
    
    @IBAction func btnCopyDidTap(_ sender: Any) {
        var copyStr = ""
        for (index, element) in dataObj.enumerated() {
            copyStr += element.original! + " => " + element.translated!
            if index < dataObj.count - 1 {
                copyStr += "\n"
            }
        }
        UIPasteboard.general.string = copyStr
    }
    
    @IBAction func btnPlayDidTap(_ sender: Any) {
        let btn = sender as! UIButton
        if btn.titleLabel?.text == NSLocalizedString("PLAY", comment: "") {
            btn.setTitle(NSLocalizedString("STOP", comment:""), for: .normal)
            let word = dataObj[talkIndex]
            isOriginal = false
            startTalking(word.original!, talkLanguage: (history?.language!.sayOriginal)!)
        }
        else{
            if talk.stopTalk() || !talk.isSpeaking(){
                btn.setTitle("PLAY", for: .normal)
            }
        }
    }
    
    //MARK: - Private functions
    private func translateRecursive(_ sender: Array<String>, index: Int = 0) {
        if sender.count > index {
            let wordObj = sender[index]
            if let translatedWord = dao.fetchTranslatedForWord(word: wordObj) {
                if let wordModel = self.dao.wordObjectFrom(original: wordObj, translated: translatedWord){
                    //Add the word to the array
                    self.dataObj.append(wordModel)
                    self.tableView.reloadData()
                }
                let i = index + 1
                //Call the method recursivily to translate all the words
                self.translateRecursive(sender, index: i)
            }
            else {
                network.completionBlock =  { (response, error) -> Void in
                    if nil == error {
                        if let wordModel = self.dao.wordObjectFrom(original: wordObj, translated: response!){
                            //Add the word to the array
                            self.dataObj.append(wordModel)
                            self.tableView.reloadData()
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
        //When we past new words need to reset the talk index
        self.talkIndex = 0
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
    func loadData() {
        //Set the talkIndex to 0 in case of the data changed
        talkIndex = 0
        //Need to load the data in viewWillAppear because the history to be shown can
        //change in settings
        if let result =  dao.fetchSelectedByEntity(UserDefaults.Entity.History) {
            history = (result as! History)
            dataObj = history!.words?.allObjects as! Array<Words>
            //Sort the array by the date the words were added to the database
            dataObj = dataObj.sorted(by:{ $0.lastUpdate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970 < $1.lastUpdate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970 })
        }
        else {
            dataObj = []
        }
        tableView.reloadData()
    }
    
    //MARK: TalkController delegate
    func didFinishTalk() {
        // If tap on the table cell the btn is disable to avoid tap again on it until the play finish is notified here
        btnPlayOutlet.isEnabled = true
        if btnPlayOutlet.titleLabel?.text == NSLocalizedString("PLAY", comment:"") {
            return
        }
        
        let playInLoop = UserDefaults.standard.bool(forKey: UserDefaults.keys.PlayInLoop)
        if talkIndex == (dataObj.count - 1) {
            talkIndex = 0
            if playInLoop == false {
                return
            }
        }
        let word = dataObj[talkIndex]
        //Update the tableView to remark the cell which is being talked now
        if isOriginal {
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: self.talkIndex, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                if let cell = self.tableView.cellForRow(at: indexPath) {
                    cell.backgroundColor = self.bgCellSelectedColor
                }
                let prevIndexPath = IndexPath(item: self.talkIndex - 1, section: 0)
                if let cell = self.tableView.cellForRow(at: prevIndexPath) {
                    cell.backgroundColor = self.bgCellColor
                }
            }
            
            if let str = word.original {
                startTalking(str, talkLanguage: (history?.language!.sayOriginal)!)
            }
            let repeatSettings = UserDefaults.standard.bool(forKey: UserDefaults.keys.RepeatOriginal)
            if !repeatSettings || repeatCounter == 3{
                isOriginal = false //The nextone to be played will be the translated one
            }
            else {
                repeatCounter += 1
            }
        }
        else {
            if let str = word.translated {
                startTalking(str, talkLanguage: (history?.language!.sayTranslated)!)
            }
            talkIndex += 1 //Increment the index to change the row
            isOriginal = true //The nextone to be read will be the original one
            repeatCounter = 1;
        }
    }
    
    //MARK: Save history
    private func saveHistory(_ words: Array<Words>) {
        let alertController = UIAlertController(title: NSLocalizedString("Save List", comment: ""), message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = NSLocalizedString("Enter a List Name", comment:"")
        }
        
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment:""), style: .default, handler: { alert -> Void in
            if let textField = alertController.textFields?[0] {
                if textField.text!.count > 0 {
                    guard let title = textField.text else {
                        return
                    }
                        if let hist = self.dao.saveHistory(words, title: title) {
                            print("\(title)")
                            self.history = hist
                            self.tableView.reloadData()
                        }
                        else {
                            print("Error Saving History.")
                        }
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment:""), style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }
}

