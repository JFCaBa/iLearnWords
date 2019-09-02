//
//  AppDelegate.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 01/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        if (UserDefaults.standard.value(forKey: "VOICE_SPEED") == nil){
            createDefaultValues()
        }
        
        return true
    }
}

extension AppDelegate{
    private func createDefaultValues(){
        UserDefaults.standard.set(0.3, forKey: "VOICE_SPEED")
        UserDefaults.standard.set(true, forKey: "REPEAT_ORIGINAL")
        UserDefaults.standard.set(true, forKey: "PLAY_IN_LOOP")
        UserDefaults.standard.synchronize()
    }
}

