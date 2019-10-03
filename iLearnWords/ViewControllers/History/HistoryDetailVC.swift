//
//  HistoryDetailVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 05/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit

class HistoryDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    // MARK: - Ivars
    var index: Int = 0
    // MARK: - Object instances
    private let coreDataManager: CoreDataManager = CoreDataManager()
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
    
    // MARK: Private functions
    private func updateView() {
        let words = viewModelHistory?.history?.words?.allObjects as! Array<Words>
        viewModelWords = MainWordsVM(wordsData: words)
    }
}

//MARK: - UITableView datasource/delegate
extension HistoryDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = viewModelWords?.wordsData.count else { return 0 }
        return  rows
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
            if let obj = viewModelHistory?.history?.words?.allObjects[indexPath.row] {
                if coreDataManager.deleteObject(obj as! Words) {
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

extension HistoryDetailVC {
    func loadData() {
        guard  let history = viewModelHistory?.history else { return }
        if let words = coreDataManager.fetchWordsForHistory(history) {
            viewModelWords = MainWordsVM(wordsData: words)
            tableView.reloadData()
        }
    }
}
