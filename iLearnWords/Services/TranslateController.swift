//
//  TranslateController.swift
//  iLearnWords
//
//  Created by Jose Catala on 24/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import Foundation

class TranslateController: NSObject {
    
    private let dao: DAOController = DAOController()
    let network = NetworkController()
    public var completionHandler: ((Array<Words>) -> Void)? = nil
    var dataObj: Array<Words> = []
    
    public func translateRecursive(_ sender: Array<String>, index: Int = 0) {
        if sender.count > index {
            let wordObj = sender[index]
            if let translatedWord = dao.fetchTranslatedForWord(word: wordObj) {
                if let wordModel = self.dao.saveWordObjectFrom(original: wordObj, translated: translatedWord){
                    //Add the word to the array
                    self.dataObj.append(wordModel)
                }
                let i = index + 1
                //Call the method recursivily to translate all the words
                self.translateRecursive(sender, index: i)
            }
            else {
                network.completionBlock =  { (response, error) -> Void in
                    if nil == error {
                        if let wordModel = self.dao.saveWordObjectFrom(original: wordObj, translated: response!){
                            //Add the word to the array
                            self.dataObj.append(wordModel)
                        }
                        let i = index + 1
                        //Call the method recursivily to translate all the words
                        self.translateRecursive(sender, index: i)
                    }
                    else{
                        print(error as Any)
                    }
                }
                network.translateString(wordObj)
            }
        }
        else {
            if dataObj.count > 0 {
//                saveHistory(dataObj)
            }
        }
    }
}
