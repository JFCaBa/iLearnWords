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
        
        let viewModel = MainWordsVM(wordsData: response)
        completion(viewModel)
    }
}
