//
//  HistoryVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 05/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController  {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Object instances
    private let coreDataManager: CoreDataManager = CoreDataManager()
    // MARK: - Ivars
    var index: Int = 0
    // MARK: - ViewModels
    var viewModelHistories: MainHistoriesVM? {
        didSet{
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let details = segue.destination as! HistoryDetailVC
        let viewModelHistory = MainHistoryVM(history: viewModelHistories?.historiesData[index])
        details.viewModelHistory = viewModelHistory
     }
}

//MARK: - UITableView datasource/delegate
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModelHistories?.numberOfHistories ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTC.reuseIdentifier, for: indexPath) as? HistoryTC else { fatalError("Unexpected Table View Cell") }
        
        if let obj = viewModelHistories?.historiesData[indexPath.row] {
            let viewModel = MainHistoryVM(history: obj)
            cell.configure(withViewModel: viewModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "gotoHistoryDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if let viewModel = viewModelHistories?.historiesData[indexPath.row] {
                if coreDataManager.deleteObject(viewModel) {
                    loadData()
                }
            }
        }
    }
}

// MARK: - Load data extension
extension HistoryVC {
    private func loadData() {
        guard let histories = coreDataManager.fetchAllByEntity(UserDefaults.Entity.History)  else { return }
        viewModelHistories = MainHistoriesVM(historiesData: histories as! Array<History>)
    }
}


