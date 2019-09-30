//
//  MainLanguageVM.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import Foundation

struct MainLanguageVM {
    
    // MARK: - Properties

    let language: Languages
    
    // MARK: -
    
    var title : String {
        return language.way ?? "Untitled"
    }

}
