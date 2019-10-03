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
        let coreData = CoreDataStack.shared
        let coreDataManager: CoreDataManager = CoreDataManager()
        guard let context = coreData.context() else { return }
        
        let originalArray = original.components(separatedBy: "\n")
        let translatedArray = translated.components(separatedBy: "\n")

        var response: Array<Words> = []
        
        for (index, element) in originalArray.enumerated() {
            let word = Words(context: context)
            word.original = element
            word.translated = translatedArray[index]
            coreDataManager.saveEntity(entity: word)
            response.append(word)
        }
        
        let history = History(context: context)
        history.isSelected = true
        history.title = title
        history.language = (coreDataManager.fetchSelectedByEntity(UserDefaults.Entity.Languages) as! Languages)
        history.addToWords(NSSet.init(array: response))
        coreDataManager.saveEntity(entity: history)
        
        do {
            try coreDataManager.managedContext?.save()
        } catch let error as NSError {
            print(error)
        }
        
        _ = coreDataManager.updateSelectedHistory(history)
        let viewModel = MainWordsVM(wordsData: response)
        completion(viewModel)
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
