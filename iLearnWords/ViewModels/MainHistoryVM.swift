//
//  MainHistoryVM.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import UIKit

struct MainHistoryVM {
    
    typealias translateDataCompletion = (MainWordsVM?) -> ()
    
    // MARK: - Properties
    let history: History?
    
    // MARK: -
    var title : String {
        return history?.title ?? "Undefined"
    }
    
    var isSelected: Bool {
        return history?.isSelected ?? false
    }
    
    var languageTitle: String {
        return history?.language?.title ?? "Undefined"
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        if history?.isSelected ?? false {
            return .checkmark
        } else {
            return .none
        }
    }
    
    func viewModelWords() -> MainWordsVM {
        var words = history?.words?.allObjects as? [Words]
        words = words?.sorted(by:{ $0.created < $1.created })
        return MainWordsVM(wordsData: words ?? [])
    }
}

extension MainHistoryVM  {
    
    // MARK: -
    func wordsViewModel(original: String, translated: String, title: String, completion: translateDataCompletion) {
        let coreDataManager: CoreDataManager = CoreDataManager()
        let originalArray = original.components(separatedBy: "\n")
        let translatedArray = translated.components(separatedBy: "\n")
        var response: Array<Words> = []
        
        for (index, element) in originalArray.enumerated() {
            if let word = wordFrom(original: element, translated: translatedArray[index]) {
                coreDataManager.saveEntity(entity: word)
                response.append(word)
            }
        }
        
        if let history = hitoryInstance() {
            history.isSelected = true
            history.title = title
            history.language = (coreDataManager.fetchSelectedByEntity(UserDefaults.Entity.Languages) as! Languages)
            history.addToWords(NSSet.init(array: response))
            coreDataManager.saveEntity(entity: history)
            
            _ = coreDataManager.updateSelectedHistory(history)
            
            do {
                try coreDataManager.managedContext?.save()
            }
            catch let error as NSError {
                print(error)
            }
        }
        
        let viewModel = MainWordsVM(wordsData: response)
        completion(viewModel)
    }
    
    func wordFrom(original: String, translated: String) -> Words? {
        let coreData = CoreDataStack.shared
        guard let context = coreData.context() else { return nil }
        let word = Words(context: context)
        word.original = original
        word.translated = translated
        return word
    }
    
    func hitoryInstance() -> History? {
        let coreData = CoreDataStack.shared
        guard let context = coreData.context() else { return nil }
        let history = History(context: context)
        return history
    }
    
    func wordViewModel(withOriginal original: String, translated: String, completion: translateDataCompletion) {
        guard let word = wordFrom(original: original, translated: translated) else {
            completion(nil)
            return
        }
        history?.addToWords(word)
        var words = history?.words?.allObjects as! [Words]
        if !words.contains(word) {
            words.append(word)
        }
        words = words.sorted(by:{ $0.created < $1.created })
        let viewModel = MainWordsVM(wordsData: words)
        let coreDataManager: CoreDataManager = CoreDataManager()
        do {
            try coreDataManager.managedContext?.save()
            completion(viewModel)
        }
        catch {
            completion(nil)
        }
    }
}

extension MainHistoryVM: HistoryRepresentable {
    var textTitle: String {
        return title
    }
    
    var textLanguage: String {
        return languageTitle
    }
    
    var accessory: UITableViewCell.AccessoryType {
        return accessoryType
    }
}
