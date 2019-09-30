//
//  TranslationData.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import Foundation

struct TranslationData {
    let code: Double
    let lang: String
    let text: Array<String>
}

extension TranslationData: JSONDecodable {
    init(decoder: JSONDecoder) throws {
        self.code = try decoder.decode(key: "code")
        self.lang = try decoder.decode(key: "lang")
        self.text = try decoder.decode(key: "text")
    }
}
