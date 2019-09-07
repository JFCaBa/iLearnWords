//
//  HistoryVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 05/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import CoreData

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Object instances
    private let dao: DAOController = DAOController()
    //MARK: - Ivars
    var dataArray: [History] = []
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
        details.dataObj = objToPass
     }
    
    //MARK: - Table view datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
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
        
        cell.detailTextLabel?.text = obj.translatedWay

        return cell
    }
    
    //MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hist = dataArray[indexPath.row]
        objToPass = (hist.hasWord?.allObjects as! Array<Words>)
        self.performSegue(withIdentifier: "gotoHistoryDetails", sender: self)
    }
}

extension HistoryVC {
    private func loadData() {
        dataArray = dao.fetchAll("History")! as! [History]
        tableView.reloadData()
    }
}
