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
    
    func wordsViewModel(original: String, translated: String, completion: translateDataCompletion) {
        let coreData: CoreDataStack = CoreDataStack()
        let originalArray = original.components(separatedBy: "\n")
        let translatedArray = translated.components(separatedBy: "\n")
        let response: Array<Words> = []
        for (index, element) in originalArray.enumerated() {
            let word = Words(context: coreData.context()!)
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
        let viewModel = MainWordsVM(wordsData: response)
        completion(viewModel)
    }
}
