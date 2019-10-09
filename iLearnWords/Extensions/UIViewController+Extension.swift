//
//  UIViewController+Extension.swift
//  iLearnWords
//
//  Created by Jose Catala on 09/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertController(withTitle title: String, text: String) {
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(text, comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: .default, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addAction(okAction)
        alertController.preferredAction = okAction
        self.present(alertController, animated: true, completion: nil)
    }
}
