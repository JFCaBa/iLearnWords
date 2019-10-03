//
//  LanguagesTC.swift
//  iLearnWords
//
//  Created by Jose Catala on 03/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import UIKit

class LanguagesTC: UITableViewCell {

    // MARK: - Type Properties
    static let reuseIdentifier = "CellLanguage"

    // MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblWay: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()

        // Configure Cell
        selectionStyle = .none
    }

    // MARK: - Configuration
    func configure(withViewModel viewModel: LanguageRepresentable) {
        lblTitle.text    = viewModel.textTitle
        lblWay.text      = viewModel.textWay
        accessoryType    = viewModel.accessoryType
    }
}
