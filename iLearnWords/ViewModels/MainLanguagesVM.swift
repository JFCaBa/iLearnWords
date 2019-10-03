//
//  MainLanguagesVM.swift
//  iLearnWords
//
//  Created by Jose Catala on 01/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import Foundation

struct MainLanguagesVM {
    
    // MARK: - Properties

    let languagesData: [Languages]
    
    // MARK: -

    var numberOfSections: Int {
        return 1
    }

    var numberOfWords: Int {
        return languagesData.count
    }
}

