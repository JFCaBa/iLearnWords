//
//  SettingsTVC.swift
//  iLearnWords
//
//  Created by Jose Catala on 02/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {

    @IBOutlet weak var voiceSpeedOutlet: UISlider!
    @IBOutlet weak var repeatOriginalOutlet: UISwitch!
    @IBOutlet weak var playInLoopOutlet: UISwitch!
    
    private let dao: DAOController = DAOController()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tweakUI()
    }

    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            self.performSegue(withIdentifier: "gotoLanguages", sender: self)
        }
        else if indexPath.row == 4 {
            self.performSegue(withIdentifier: "gotoHistory", sender: self)
        }
    }

    //MARK: - Actions
    @IBAction func voiceSpeedDidChangeValue(_ sender: Any){
        let slider = sender as! UISlider
        UserDefaults.standard.set(slider.value, forKey: UserDefaults.keys.VoiceSpeed)
        notifyChanges()
    }
    
    @IBAction func repeatOriginalDidChangeValue(_ sender: Any){
        let sw = sender as! UISwitch
        UserDefaults.standard.set(sw.isOn, forKey: UserDefaults.keys.RepeatOriginal)
        notifyChanges()
    }
    
    @IBAction func playInLoopDidChangeValue(_ sender: Any) {
        let sw = sender as! UISwitch
        UserDefaults.standard.set(sw.isOn, forKey: UserDefaults.keys.PlayInLoop)
        notifyChanges()
    }
    
    @IBAction func btnResetDidTap(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("This action will remove the words from your phone", comment:""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("YES", comment:""), style: .destructive) { (alert: UIAlertAction) in
            if self.dao.cleanData(UserDefaults.Entity.Words) {
                print("Words flushed")
            }
            else {
                print("Error flushing Words")
            }
            
            if self.dao.cleanData(UserDefaults.Entity.History) {
                print("History flushed")
            }
            else {
                print("Error flushing History")
            }
            
            if self.dao.cleanData(UserDefaults.Entity.Languages) {
                print("History flushed")
            }
            else {
                print("Error flushing Languages")
            }
            
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("NO", comment:""), style: .default) { (alert: UIAlertAction) in
            
        })
        
        self.present(alert, animated: false, completion: nil)
    }
    
}

extension SettingsTVC{
    private func notifyChanges(){
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DID_CHANGE_SETTINGS"), object: nil)
    }
    
    private func tweakUI(){
        voiceSpeedOutlet.value = UserDefaults.standard.float(forKey: UserDefaults.keys.VoiceSpeed);
        repeatOriginalOutlet.isOn = UserDefaults.standard.bool(forKey: UserDefaults.keys.RepeatOriginal)
        playInLoopOutlet.isOn = UserDefaults.standard.bool(forKey: UserDefaults.keys.PlayInLoop)
    }
}
