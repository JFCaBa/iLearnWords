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
        return word.original ?? "Undefined"
    }
    
    var translatedWord: String {
        return word.translated ?? "Undefined"
    }
}

extension MainWordVM: MainRepresentable {
    var textOriginal: String {
<<<<<<< Updated upstream
        return originalWord
    }
    
    var textTranslated: String {
        return translatedWord
=======
        guard let original = word.original else { return "Undefined" }
        return original
    }
    
    var textTranslated: String {
        guard let translated = word.translated else { return "Undefined" }
        return translated
>>>>>>> Stashed changes
    }
}
