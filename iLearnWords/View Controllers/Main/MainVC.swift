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
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnPlayOutlet: UIButton!
    
    // MARK: -
    
    var viewModelWords: MainWordsVM? {
        didSet {
            updateView()
        }
    }
    
    var viewModelHistory: MainHistoryVM? {
        didSet {
            updateView()
        }
    }
    
    var viewModelLanguage: MainLanguageVM? {
        didSet {
            updateView()
        }
    }
    
    private let coreDataManager: CoreDataManager = CoreDataManager()
    
    private lazy var dataManager = {
        return DataManager(APIKey: API.key)
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        loadData()
    }
    
    //MARK: - Actions
    @IBAction func btnSettingsDidTap(_ sender: Any) {
        self.performSegue(withIdentifier: segueSettings, sender: self)
    }
    
    @IBAction func btnCardsDidTap(_ sender: Any) {
        self.performSegue(withIdentifier: segueCardsGame, sender: self)
    }
    
    @IBAction func btnPasteDidTap(_ sender: Any) {
        guard let toPaste = UIPasteboard.general.string else { return }
        translateData(data: toPaste)
    }
    
    @IBAction func btnDeleteDidTap(_ sender: Any) {
        //        viewModel?.dataObj.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func btnCopyDidTap(_ sender: Any) {
        var copyStr = ""
       
        UIPasteboard.general.string = copyStr
    }
    
    @IBAction func btnPlayDidTap(_ sender: Any) {
        let btn = sender as! UIButton
        if btn.titleLabel?.text == NSLocalizedString("PLAY", comment: "") {
            btn.setTitle(NSLocalizedString("STOP", comment:""), for: .normal)
        }
        else {

        }
    }
    
    //MARK: - Private functions
    private func translateData(data: String) {
        
        dataManager.tranlationFor(word: data) { (response, error) in
            if let error = error {
                print(error)
            } else if let response = response {
                // Configure the viewModel
                self.viewModelHistory?.wordsViewModel(original: data, translated: response, completion: { (viewModel) in
                    self.viewModelWords = viewModel
                })
            }
        }
    }
    
    private func updateView() {
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
            
        }
        else {
            //Error
        }
    }
}

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
        
        if let viewModel = viewModelWords?.viewModel(for: indexPath.row) {
            cell.configure(withViewModel: viewModel)
        }
        return cell
    }
    
    //Set the history title as Title in the header section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModelHistory?.title
    }
    
    //MARK: - Table view delegate
    // Will play the Word in the tapped row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Unselect the tapped row
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension MainVC {
    func loadData() {
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
}
