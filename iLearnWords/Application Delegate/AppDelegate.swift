//
//  AppDelegate.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//
// *********************************************************************************
// *                                                                               *
// * CORE DATA STACK HAS BEEN MOVED TO /Configuration/CoreData/CoreDataStack.swift *
// *                                                                               *
// *********************************************************************************

import UIKit
//PODs
import Fabric
import Crashlytics
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        IQKeyboardManager.shared.enable = true
        
        if (UserDefaults.standard.value(forKey: UserDefaults.keys.RunOnce) == nil){
            createDefaultValues()
        }

        return true
    }
}

extension AppDelegate{
    private func createDefaultValues() {
        /** Create the Languages entity content */
        let coreData: CoreDataManager = CoreDataManager()
        coreData.saveLanguagesInCoreDataWith()
        
        /** Create the default settings values */
        let user = UserDefaults.standard
        
        //App did run once
        user.set(true, forKey: UserDefaults.keys.RunOnce)
        
        //Syntheziser
        user.set(0.33, forKey: UserDefaults.keys.VoiceSpeed)
        user.set(false, forKey: UserDefaults.keys.RepeatOriginal)
        user.set(true, forKey: UserDefaults.keys.PlayInLoop)
        
        //Colors
        user.setColor(color: UIColor.lightGray, forKey: UserDefaults.keys.CellSelectedBackgroundColor)
        user.setColor(color: UIColor.white, forKey: UserDefaults.keys.CellBackgroundColor)
        
        //Synchronize changes
        UserDefaults.standard.synchronize()
    }
}

