//
//  HistoryDetailVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 05/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import MKProgress

class HistoryDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    // MARK: - Ivars
    var index: Int = 0
    // MARK: - Object instances
    private let coreDataManager: CoreDataManager = CoreDataManager()
    private lazy var dataManager = {
        return DataManager(APIKey: API.key)
    }()
    // MARK: - ViewModels
    var viewModelHistory: MainHistoryVM? {
        didSet {
            updateView()
        }
    }
    var viewModelWords: MainWordsVM?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let edit = segue.destination as! WordsEditVC
        if let word = viewModelWords?.wordsData[index] {
            edit.viewModelWord = MainWordVM(word: word)
        }
    }
    
    //MARK: - Actions
    @IBAction func switchDidTap(_ sender: Any) {
        swithHistory()
    }
    
    @IBAction func btnAddWordDidTap(_ sender: Any) {
        addWord()
    }
    
    // MARK: Private functions
    private func updateView() {
        viewModelWords = viewModelHistory?.viewModelWords()
    }
}

//MARK: - UITableView datasource/delegate
extension HistoryDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModelWords?.numberOfWords ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryDetailTC.reuseIdentifier, for: indexPath) as? HistoryDetailTC else { fatalError("Unexpected Table View Cell") }
        
        if let word = viewModelWords?.wordsData[indexPath.row] {
            let viewModel = MainWordVM(word: word)
            cell.configure(withViewModel: viewModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if let obj = viewModelWords?.wordsData[indexPath.row] {
                if coreDataManager.deleteObject(obj) {
                    loadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "gotoEditWord", sender: self)
    }
}

// MARK: - Load data extension
extension HistoryDetailVC {
    func loadData() {
        viewModelWords = viewModelHistory?.viewModelWords()
        tableView.reloadData()
    }
    
    private func translateWord(withWord word: String) {
        MKProgress.show()
        dataManager.tranlationFor(word: word) { [weak self] (response, error) in
            MKProgress.hide()
            if let error = error {
                self?.showAlertController(withTitle: NSLocalizedString("Error!", comment: "") , text: error.localizedDescription)
            } else if let response = response {
                // Configure the viewModel
                self?.viewModelHistory?.wordViewModel(withOriginal:word, translated:response, completion: { (viewModel) in
                    self?.viewModelWords = viewModel
                    self?.tableView.reloadData()
                })
            }
        }
    }
}

// MARK: - Alert confirmations
extension HistoryDetailVC {
    
    func swithHistory() {
        let alertController = UIAlertController(title: NSLocalizedString("Switch to this History", comment:""), message: "", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment:""), style: .default, handler: { alert -> Void in
            //Set the isSelected property to yes
            let ok = self.coreDataManager.updateSelectedHistory((self.viewModelHistory?.history)!)
            if ok {
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment:""), style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        alertController.preferredAction = yesAction
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addWord() {
        let alertController = UIAlertController(title: NSLocalizedString("Add Word to History", comment: ""), message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = NSLocalizedString("Enter the Word", comment:"")
        }
        
        let saveAction = UIAlertAction(title: NSLocalizedString("Add", comment:""), style: .default, handler: { alert -> Void in
            if let textField = alertController.textFields?[0] {
                if textField.text!.count > 0 {
                    guard let word = textField.text else { return }
                    self.translateWord(withWord: word)
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
