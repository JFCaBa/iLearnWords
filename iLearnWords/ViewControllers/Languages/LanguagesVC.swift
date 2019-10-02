//
//  LanguagesVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 04/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import Foundation

class LanguagesVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Object instances
    private let coreDataManager: CoreDataManager = CoreDataManager()
    // MARK: ViewModels
    var viewModelLanguages: MainLanguagesVM? {
        didSet{
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        loadData()
    }
}

// MARK: - UITableView datasource/delegate
extension LanguagesVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = viewModelLanguages?.languagesData.count else { return 0 }
        return  rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
                // Never fails:
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
            }
            return cell
        }()
        if let viewModel = viewModelLanguages?.languagesData[indexPath.row] {
            if let title = viewModel.title {
                cell.textLabel?.text = title
            }
            else {
                cell.textLabel?.text = "Untitled"
            }
            
            if viewModel.isSelected {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
            
            cell.detailTextLabel?.text = viewModel.title
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = viewModelLanguages?.languagesData[indexPath.row] {
            //TODO: alertcontroller to confirm
            _ = coreDataManager.updateSelectedLanguage(model)
            //loadData()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - Load data extension
extension LanguagesVC {
    private func loadData() {
        if let data = coreDataManager.fetchAllByEntity(UserDefaults.Entity.Languages){
            viewModelLanguages = MainLanguagesVM(languagesData: data as! Array<Languages>)
        }
    }
}
