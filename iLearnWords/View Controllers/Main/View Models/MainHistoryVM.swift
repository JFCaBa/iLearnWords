//
//  MainHistoryVM.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import Foundation

struct MainHistoryVM {
    
    typealias translateDataCompletion = (MainWordsVM?) -> ()
    
    // MARK: - Properties

    let history: History?
    
    // MARK: -

    var title : String {
        return history?.title ?? ""
    }
}

extension MainHistoryVM  {
    
    // MARK: -
    
    func wordsViewModel(original: String, translated: String, title: String, completion: translateDataCompletion) {
        let coreData = CoreDataStack.shared
        let coreDataManager: CoreDataManager = CoreDataManager()
        guard let context = coreData.context() else { return }
        
        let originalArray = original.components(separatedBy: "\n")
        let translatedArray = translated.components(separatedBy: "\n")
<<<<<<< Updated upstream
        let response: Array<Words> = []
=======
        var response: Array<Words> = []
        
>>>>>>> Stashed changes
        for (index, element) in originalArray.enumerated() {
            let word = Words(context: context)
            word.original = element
            word.translated = translatedArray[index]
            let uuid = UUID().uuidString
            do {
                word.recordID = try NSKeyedArchiver.archivedData(withRootObject: uuid, requiringSecureCoding: false)
            }
            catch {
                print("Error")
                return
            }
            word.recordName = UserDefaults.Entity.Words + UUID().uuidString
            word.lastUpdate = Date()
        }
        
        let history = History(context: context)
        history.isSelected = true
        history.title = title
        let uuid = UUID().uuidString
        do {
            history.recordID = try NSKeyedArchiver.archivedData(withRootObject: uuid, requiringSecureCoding: false)
        }
        catch {
            print("Error")
            return
        }
        history.recordName = UserDefaults.Entity.History + UUID().uuidString
        history.lastUpdate = Date()
        history.addToWords(NSSet.init(array: response))
        history.language = (coreDataManager.fetchSelectedByEntity(UserDefaults.Entity.Languages) as! Languages)
        do {
            try coreDataManager.managedContext?.save()
        } catch let error {
            print(error)
        }
        let viewModel = MainWordsVM(wordsData: response)
        completion(viewModel)
    }
}
