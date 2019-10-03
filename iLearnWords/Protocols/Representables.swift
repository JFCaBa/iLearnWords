//
//  MainRepresentable.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import UIKit

protocol MainRepresentable {
    var textOriginal: String { get }
    var textTranslated: String { get }
}

protocol HistoryRepresentable {
    var textTitle: String { get }
    var textLanguage: String { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
}

protocol LanguageRepresentable {
    var textTitle: String { get }
    var textSayOriginal: String { get }
    var textSayTranslated: String { get }
    var textWay: String { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
}
