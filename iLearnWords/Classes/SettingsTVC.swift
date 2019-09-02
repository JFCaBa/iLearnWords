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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    //MARK: - Actions
    @IBAction func voiceSpeedDidChangeValue(_ sender: Any){
        let slider = sender as! UISlider
        UserDefaults.standard.set(slider.value, forKey: "VOICE_SPEED")
        notifyChanges()
    }
    
    @IBAction func repeatOriginalDidChangeValue(_ sender: Any){
        let sw = sender as! UISwitch
        UserDefaults.standard.set(sw.isOn, forKey: "REPEAT_ORIGINAL")
        notifyChanges()
    }
    
    @IBAction func playInLoopDidChangeValue(_ sender: Any) {
        let sw = sender as! UISwitch
        UserDefaults.standard.set(sw.isOn, forKey: "PLAY_IN_LOOP")
        notifyChanges()
    }
}

extension SettingsTVC{
    private func notifyChanges(){
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DID_CHANGE_SETTINGS"), object: nil)
    }
    
    private func tweakUI(){
        voiceSpeedOutlet.value = UserDefaults.standard.float(forKey: "VOICE_SPEED");
        repeatOriginalOutlet.isOn = UserDefaults.standard.bool(forKey: "REPEAT_ORIGINAL")
        playInLoopOutlet.isOn = UserDefaults.standard.bool(forKey: "PLAY_IN_LOOP")
    }
}
