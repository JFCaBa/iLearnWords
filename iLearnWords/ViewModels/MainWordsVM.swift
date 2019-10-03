//
//  MainVM.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import Foundation

struct MainWordsVM {
    
    // MARK: - Properties

    let wordsData: [Words]
    
    // MARK: -

    var numberOfSections: Int {
        return 1
    }

    var numberOfWords: Int {
        return wordsData.count
    }
    
    func viewModel(for index: Int) -> MainWordVM {
        return MainWordVM(word: wordsData[index])
    }
}

