//
//  NetworkController.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 01/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import Alamofire

struct API {
    //Free key from Yandex.com
    //https://translate.yandex.com/developers/keys
    static let key =  "trnsl.1.1.20190621T071428Z.f5242913863515ce.ad3d081c06e886ba5c5a34a836a10c817dd16b45"
    static let baseURL = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=%@&text=%@&lang=%@&format=plain"
}

class NetworkController: NSObject {
    
    var completionBlock: ((String?, NSError?) -> Void)? = nil
    var translateBlock: ((String?) -> Void)? = nil
    
    //MARK: Initialization
    override init() {

    }

    //MARK: Public
    /** Returns in the var block the translation for the passed word*/
    public func translateStringOfWords(_ wordsStr: String){
        
        self.completionBlock =  { (response, error) -> Void in
            //Do the stuff on completion
            if nil == error{
                self.translateBlock?(response)
            }
            else{
                self.translateBlock?(nil)
                print(error as Any)
            }
        }
        self.translateString(wordsStr)
    }
    
    /** Makes the call to Yandex translation API. The url is compossed using the language settins stored in the UserDefaults preferences*/
    public func translateString(_ string: String) {
        if string.count == 0{
            return
        }
        
        let translateWay = UserDefaults.standard.object(forKey: UserDefaults.keys.TranslateWay) as? String ?? "ru-en"
        let escapedString = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let str = String(format: API.baseURL, API.key, escapedString ?? "",translateWay)
        
        guard let url = URL(string: str) else {
            return
        }
        
        var err : NSError? = nil
        
        AF.request(url, method: .get)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    // Do something with the json.
                    if let result = json as? NSDictionary
                    {
                        if let textArray = result.object(forKey: "text")
                        {
                            let textA = textArray as! NSArray
                            let result2 = textA.firstObject as! String
                            //print(result as Any)
                            if let completionBlock = self.completionBlock {
                                completionBlock(result2 == "" ? nil : result2, err);
                                return
                            }
                        }
                    }
                    self.completionBlock?(nil,err)
                    break
                case .failure(let error):
                    err = error as NSError
                    print(error)
                    break
                }
                self.completionBlock?(nil,err)
        }
    }
}
