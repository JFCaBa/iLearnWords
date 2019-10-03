//
//  MainLanguageVM.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import UIKit

struct MainLanguageVM {
    
    // MARK: - Properties
    let language: Languages?
    
    // MARK: -
    var title : String {
        return language?.title ?? "Undefined"
    }
    
    var sayOriginal: String {
        return language?.sayOriginal ?? "Undefined"
    }
    
    var sayTranslated: String {
        return language?.sayTranslated ?? "Undefined"
    }
    
    var way: String {
        return language?.way ?? "Undefined"
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        if language?.isSelected ?? false {
            return .checkmark
        } else {
            return .none
        }
    }
}

extension MainLanguageVM: LanguageRepresentable {
    
    var textTitle: String {
        return title
    }
    
    var textSayOriginal: String {
        return sayOriginal
    }
    
    var textSayTranslated: String {
        return sayTranslated
    }
    
    var textWay: String {
        return way
    }
    
    var accessory: UITableViewCell.AccessoryType {
        return accessoryType
    }
}
