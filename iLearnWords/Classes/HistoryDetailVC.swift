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
    
    var dataObj: Array<Words> = []
    public var history: History?
    var index: Int = 0
    private let dao: DAOController = DAOController()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        dataObj = (history!.hasWord?.allObjects as! Array<Words>)
        dataObj = dataObj.sorted(by:{ $0.date!.timeIntervalSince1970 < $1.date!.timeIntervalSince1970 })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let edit = segue.destination as! WordsEditVC
        edit.dataObj = dataObj[index]
    }
    
    //MARK: - Table view datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellMain") else {
                // Never fails:
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "CellMain")
            }
            return cell
        }()
        let word: Words = dataObj[indexPath.row]
        cell.textLabel?.text = word.original
        cell.detailTextLabel?.text = word.translated
        return cell
    }
    
    //MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "gotoEditWord", sender: self)
    }
    
    //MARK: - Actions
    @IBAction func switchDidTap(_ sender: Any) {
        let alertController = UIAlertController(title: "Switch to this History", message: "", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { alert -> Void in
            //Unselect the previous history
            if self.dao.unSelectHistory() {
                //Set the isSelected property to yes
                self.history?.isSelected = true
                //Back to the main screen
                self.navigationController?.popToRootViewController(animated: true)
            }
            else {
                print("Error: The History couldn't be changed")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        alertController.preferredAction = yesAction
        
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
