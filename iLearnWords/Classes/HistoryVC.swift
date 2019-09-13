//
//  HistoryVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 05/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Object instances
    private let dao: DAOController = DAOController()
    //MARK: - Ivars
    var dataArray: Array<History> = []
    var index: Int = 0
    var objToPass: Array<Words>?
    
    //MARK: - Lifecycle
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
    
     //MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let details = segue.destination as! HistoryDetailVC
        details.history = dataArray[index]
     }
    
    //MARK: - Table view datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    let bgCellSelectedColor =  UserDefaults.standard.colorForKey(key: UserDefaults.keys.CellSelectedBackgroundColor)
    let bgCellColor = UserDefaults.standard.colorForKey(key: UserDefaults.keys.CellBackgroundColor)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
                // Never fails:
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
            }
            return cell
        }()
        
        let obj = dataArray[indexPath.row]
        if let title = obj.title {
            cell.textLabel?.text = title
        }
        else {
            cell.textLabel?.text = "Untitled"
        }
        
        if obj.isSelected {
            cell.backgroundColor = bgCellSelectedColor
        }
        else {
            cell.backgroundColor = bgCellColor
        }
        
        cell.detailTextLabel?.text = obj.language?.title

        return cell
    }
    
    //MARK: - Table view delegate
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
            let obj = dataArray[indexPath.row]
            if dao.deleteObject(obj) {
                if let index = dataArray.firstIndex(of: obj) {
                    dataArray.remove(at: index)
                }
                tableView.reloadData()
            }
        }
    }
}

extension HistoryVC {
    private func loadData() {
        dataArray = dao.fetchAll()
        tableView.reloadData()
    }
}
