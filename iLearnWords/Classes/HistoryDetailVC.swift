//
//  HistoryDetailVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 05/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import CoreData

class HistoryDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    public var dataObj: Array<Words>?
    private let dao: DAOController = DAOController()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    //MARK: - Table view datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObj!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellMain") else {
                // Never fails:
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "CellMain")
            }
            return cell
        }()
        let word: Words = (dataObj?[indexPath.row])!
        cell.textLabel?.text = word.original
        cell.detailTextLabel?.text = word.translated
        return cell
    }
    
    //MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = dataObj![indexPath.row] as Words
    }
    
    //MARK: - Actions
    @IBAction func switchDidTap(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Switch to History", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Yes", style: .default, handler: { alert -> Void in
            //Set the isSelected property to yes
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteDidTap(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete From History", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Yes", style: .default, handler: { alert -> Void in
//            if self.dao.deleteObject(self.dataObj!) {
//                print("History deleted")
//                self.navigationController?.popViewController(animated: true)
//            }
//            else {
//                print("Error deleting History")
//            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }
}
