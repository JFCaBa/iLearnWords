//
//  Languages+CoreDataClass.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//
//

import Foundation
import CoreData


public class Languages: NSManagedObject {

    func suportedLanguages() -> [[String: String]] {
        let langDic = [["title":"Russian to English",
                        "sayOriginal":"ru_RU",
                        "sayTranslate":"en_GB",
                        "way":"ru-en",
                        "isSelected":"1"],
                       ["title":"English to Russian",
                        "sayOriginal":"en_GB",
                        "sayTranslate":"ru_RU",
                        "way":"en-ru",
                        "isSelected":"0"]
        ]
        return langDic
    }
}
