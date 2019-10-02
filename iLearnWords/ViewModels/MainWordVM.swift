//
//  MainWordVM.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import Foundation

struct MainWordVM {
    
    // MARK: - Properties
    let word: Words
    
    // MARK: -
    var originalWord: String {
        return word.original ?? ""
    }
    
    var translatedWord: String {
        return word.translated ?? ""
    }
}

extension MainWordVM: MainRepresentable {
    var textOriginal: String {
        return originalWord
    }
    
    var textTranslated: String {
        return translatedWord
    }
}
