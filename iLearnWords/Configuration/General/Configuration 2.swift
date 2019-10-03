//
//  Configuration.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import Foundation

struct API {
    //Free key from Yandex.com
    //https://translate.yandex.com/developers/keys
    //Test with: https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20190621T071428Z.f5242913863515ce.ad3d081c06e886ba5c5a34a836a10c817dd16b45&text=да&lang=ru-en&format=plain
    static let key     =  "trnsl.1.1.20190621T071428Z.f5242913863515ce.ad3d081c06e886ba5c5a34a836a10c817dd16b45"
    static let baseURL = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=%@&text=%@&lang=%@&format=plain"
}

struct TranslationLanguages {
    static let languagesArray = [["title":"Russian to English",
                    "sayOriginal":"ru_RU",
                    "sayTranslated":"en_GB",
                    "way":"ru-en",
                    "isSelected":"1"],
                   ["title":"English to Russian",
                    "sayOriginal":"en_GB",
                    "sayTranslated":"ru_RU",
                    "way":"en-ru",
                    "isSelected":"0"]
    ]
}
