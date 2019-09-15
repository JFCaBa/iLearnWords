//
//  AppDelegate.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 01/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import CoreData
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
        
        if (UserDefaults.standard.value(forKey: UserDefaults.keys.VoiceSpeed) == nil){
            //createDefaultValues()
        }
        createDefaultValues()
        
        return true
    }
    
    // MARK: - Core Data stack
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "iLearnWords")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate{
    private func createDefaultValues() {
        
        /** Create the default settings values */
        let user = UserDefaults.standard
        //Syntheziser
        user.set(0.33, forKey: UserDefaults.keys.VoiceSpeed)
        user.set(false, forKey: UserDefaults.keys.RepeatOriginal)
        user.set(true, forKey: UserDefaults.keys.PlayInLoop)
        
        //Colors
        user.setColor(color: UIColor.groupTableViewBackground, forKey: UserDefaults.keys.CellSelectedBackgroundColor)
        user.setColor(color: UIColor.white, forKey: UserDefaults.keys.CellBackgroundColor)
        //Synchronize changes
        UserDefaults.standard.synchronize()
        
        /** Create the Languages entity content */
        let dao: DAOController = DAOController()
        dao.synchronizeData()
    }
}

