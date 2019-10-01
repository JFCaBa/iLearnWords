//
//  MainHistoriesVM.swift
//  iLearnWords
//
//  Created by Jose Catala on 01/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import Foundation

struct MainHistoriesVM {
    
    // MARK: - Properties

    let historiesData: [History]
    
    // MARK: -

    var numberOfSections: Int {
        return 1
    }

    var numberOfWords: Int {
        return historiesData.count
    }
    
    func viewModel(for index: Int) -> MainHistoryVM {
        return MainHistoryVM(history: historiesData[index])
    }
}
