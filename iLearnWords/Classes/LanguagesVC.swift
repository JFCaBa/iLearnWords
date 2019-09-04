//
//  LanguagesVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 04/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class LanguagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Object instances
    private let dao: DAOController = DAOController()
    //MARK: - Ivars
    var dataArray: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        loadData()
    }

    //MARK: - Table view datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let obj = dataArray[indexPath.row]
        cell.textLabel?.text = (obj.value(forKey: "title") as! String)
        let way = UserDefaults.standard.value(forKey: "TRANSLATE_WAY") ?? "ru-en"
        let storedWay = obj.value(forKey: "short") ?? "ru-en"
        if (way as! String == storedWay as! String) {
            cell.textLabel?.textColor = UIColor.blue
        }
        else {
            cell.textLabel?.textColor = UIColor.black
        }
        
        return cell
    }
    
    //MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = dataArray[indexPath.row]
        let short = obj.value(forKey: "short") as! String
        let say = obj.value(forKey: "say") as! String
        UserDefaults.standard.set(short, forKey: "TRANSLATE_WAY")
        UserDefaults.standard.set(say, forKey: "TALK_LANGUAGE")
        UserDefaults.standard.synchronize()
        tableView.reloadData()
    }
    
    //MARK: - Actions
    @IBAction func addDidTap(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add Language", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Russian to English/ru-en/ru_RU"
        }
        
        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
            if let textField = alertController.textFields?[0] {
                if textField.text!.count > 0 {
                    let content = textField.text?.components(separatedBy: "/") ?? ["Russian to English","ru-en", "ru_RU"]
                    let title = content[0]
                    let short = content[1]
                    let say = content[2]
                    if self.dao.saveLanguage(title: title, short: short, say: say) {
                        print("Language \(title) \(short) \(say) saved")
                    }
                    else {
                        print("Error saving language")
                    }
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension LanguagesVC {
    private func loadData() {
        dataArray = dao.fetchAll("Languages")!
        tableView.reloadData()
    }
}
