//
//  CardsGameVM.swift
//  iLearnWords
//
//  Created by Jose Catala on 01/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import Foundation

struct CardsGameVM {
    
    // MARK: - Properties
    let words: [Words]
    let index = 0
    
    // MARK: -
    var originalWord: String {
        return words[index].original ?? "Undefined"
    }
    
    var translatedWord: String {
        return words[index].translated ?? "Undefined"
    }
}

extension CardsGameVM: MainRepresentable {
    var textOriginal: String {
        return originalWord
    }
    
    var textTranslated: String {
        return translatedWord
    }
}
