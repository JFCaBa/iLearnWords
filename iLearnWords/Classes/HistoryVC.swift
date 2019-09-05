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
    var dataArray: [NSManagedObject] = []
    var objToPass: NSManagedObject?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
        details.obj = objToPass
     }
    
    //MARK: - Table view datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let obj = dataArray[indexPath.row]
        if let title = obj.value(forKey: "title") {
            cell.textLabel?.text = (title as! String)
        }
        else {
            cell.textLabel?.text = "Untitled"
        }
        
        cell.detailTextLabel?.text = (obj.value(forKey: "date") as! String)

        return cell
    }
    
    //MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        objToPass = dataArray[indexPath.row]
        self.performSegue(withIdentifier: "gotoHistoryDetails", sender: self)
    }
}

extension HistoryVC {
    private func loadData() {
        dataArray = dao.fetchAll("History")!
        tableView.reloadData()
    }
}
