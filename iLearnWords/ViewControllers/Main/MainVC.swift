//
//  MainVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import UIKit
import MKProgress

class MainVC: UIViewController {
    
    // MARK: - Constants
    private let segueSettings = "gotoSettings"
    private let segueCardsGame = "gotoCardsGame"
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnPlayOutlet: UIButton!
    // MARK: - Ivars
    var talkIndex = 0
    // MARK: - ViewModels
    var viewModelWords: MainWordsVM? {
        didSet {
            updateView()
        }
    }
    
    var viewModelHistory: MainHistoryVM? {
        didSet {
            updateHeader()
        }
    }
    
    var viewModelLanguage: MainLanguageVM? {
        didSet {
            updateTitle()
        }
    }
    
    // MARK: - Objects
    private let coreDataManager: CoreDataManager = CoreDataManager()
    private let talkManager = TalkManager.shared
    
    private lazy var dataManager = {
        return DataManager(APIKey: API.key)
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        talkManager.delegate      = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoCardsGame" {
            let cards = segue.destination as! CardsGameVC
            cards.viewModelWords = viewModelWords
            cards.viewModelLanguage = viewModelLanguage
        }
    }
    
    // MARK: - Actions
    @IBAction func btnSettingsDidTap(_ sender: Any) {
        self.performSegue(withIdentifier: segueSettings, sender: self)
    }
    
    @IBAction func btnCardsDidTap(_ sender: Any) {
        self.performSegue(withIdentifier: segueCardsGame, sender: self)
    }
    
    @IBAction func btnPasteDidTap(_ sender: Any) {
        guard let toPaste = UIPasteboard.general.string else { return }
        saveHistory(data: toPaste)
    }
    
    @IBAction func btnDeleteDidTap(_ sender: Any) {
        //        viewModel?.dataObj.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func btnCopyDidTap(_ sender: Any) {
//        var copyStr = ""
//
//        UIPasteboard.general.string = copyStr
    }
    
    @IBAction func btnPlayDidTap(_ sender: Any) {
        let btn = sender as! UIButton
        if btn.titleLabel?.text == NSLocalizedString("PLAY", comment: "") {
            btn.setTitle(NSLocalizedString("STOP", comment:""), for: .normal)
            guard let viewModel = viewModelHistory else { return }
            talkManager.sayText(viewModel: viewModel)
        }
        else {
            let success = talkManager.stopTalk()
            if success {
                btn.setTitle(NSLocalizedString("PLAY", comment:""), for: .normal)
            }
        }
    }
    
    // MARK: - Private functions
    private func
        updateView() {
        MKProgress.hide()
        
        if nil != viewModelWords {
            tableView.reloadData()
        }
        else {
            //Error
        }
    }
    
    private func updateTitle() {
        if nil != viewModelLanguage {
            title = viewModelLanguage?.title
        }
        else {
            //Error
        }
    }
    
    private func updateHeader() {
        if nil != viewModelHistory {
            tableView.reloadData()
        }
        else {
            //Error
        }
    }
}

// MARK: - UITableView stuff
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = viewModelWords?.wordsData.count else { return 0 }
        return  rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTC.reuseIdentifier, for: indexPath) as? MainTC else { fatalError("Unexpected Table View Cell") }
        
        if let word = viewModelWords?.wordsData[indexPath.row] {
            let viewModel = MainWordVM(word: word)
            cell.configure(withViewModel: viewModel)
        }
        return cell
    }
    
    //Set the history title as Title in the header section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModelHistory?.title
    }
    
    // MARK: - Table view delegate
    /// Will play the Word in the tapped row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Unselect the tapped row
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - Data related extension
extension MainVC {
    func loadData() {
        guard let selectedLang = coreDataManager.fetchSelectedByEntity(UserDefaults.Entity.Languages) else {
            viewModelLanguage = MainLanguageVM(language: nil)
            return
        }
        viewModelLanguage = MainLanguageVM(language: selectedLang as? Languages)
        
        guard let hist = coreDataManager.fetchSelectedByEntity(UserDefaults.Entity.History) else {
            viewModelHistory = MainHistoryVM(history: nil)
            return
        }
        let history = hist as! History
        viewModelHistory = MainHistoryVM(history: history)
        viewModelWords = MainWordsVM(wordsData: history.words?.allObjects as! [Words])
        guard let lang = history.language else { return }
        viewModelLanguage = MainLanguageVM(language: lang)
    }
    
    private func saveHistory(data: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Save List", comment: ""), message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = NSLocalizedString("Enter a List Name", comment:"")
        }
        
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment:""), style: .default, handler: { alert -> Void in
            if let textField = alertController.textFields?[0] {
                if textField.text!.count > 0 {
                    guard let title = textField.text else { return }
                    self.translateData(data: data, title: title)
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
    
    private func translateData(data: String, title: String) {
        MKProgress.show()
        dataManager.tranlationFor(word: data) { (response, error) in
            if let error = error {
                print(error)
            } else if let response = response {
                // Configure the viewModel
                self.viewModelHistory?.wordsViewModel(original: data, translated: response, title: title, completion: { (viewModel) in
                    self.viewModelWords = viewModel
                    MKProgress.hide()
                })
            }
        }
    }
}

// MARK: - TalkManager Delegate
extension MainVC: TalkerDelegate {
    // MARK: TalkController delegate
    func didFinishTalk() {
        // If tap on the table cell the btn is disable to avoid tap again on it until the play finish is notified here
        btnPlayOutlet.isEnabled = true
        if btnPlayOutlet.titleLabel?.text == NSLocalizedString("PLAY", comment:"") {
            return
        }
        
        let playInLoop = UserDefaults.standard.bool(forKey: UserDefaults.keys.PlayInLoop)
        if playInLoop {
            if let viewModel = viewModelHistory {
                talkManager.sayText(viewModel: viewModel)
            }
        }
    }
}
