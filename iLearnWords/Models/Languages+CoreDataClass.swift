//
//  Languages+CoreDataClass.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 28/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Languages)
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
