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
    var dataArray: [Languages] = []
    
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
    
    let bgCellSelectedColor =  UserDefaults.standard.colorForKey(key: UserDefaults.keys.CellSelectedBackgroundColor)
    let bgCellColor = UserDefaults.standard.colorForKey(key: UserDefaults.keys.CellBackgroundColor)
    let way = UserDefaults.keys.TranslateWay
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
                // Never fails:
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
            }
            return cell
        }()
        let obj = dataArray[indexPath.row]
        cell.textLabel?.text = obj.title
        if way == obj.way {
            cell.backgroundColor = bgCellSelectedColor
        }
        else {
            cell.backgroundColor = bgCellColor
        }
        return cell
    }
    
    //MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = dataArray[indexPath.row]
        UserDefaults.standard.set(obj.way, forKey: UserDefaults.keys.TranslateWay)
        UserDefaults.standard.set(obj.sayOriginal, forKey: UserDefaults.keys.TalkOriginal)
        UserDefaults.standard.synchronize()
        tableView.reloadData()
    }
}

extension LanguagesVC {
    private func loadData() {
        dataArray = dao.fetchLanguages()!
        tableView.reloadData()
    }
}
