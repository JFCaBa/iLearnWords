//
//  HistoryTC.swift
//  iLearnWords
//
//  Created by Jose Catala on 01/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import UIKit

class HistoryTC: UITableViewCell {

    // MARK: - Type Properties
    static let reuseIdentifier = "CellHistory"

    // MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()

        // Configure Cell
        selectionStyle = .none
    }

    // MARK: - Configuration
    func configure(withViewModel viewModel: HistoryRepresentable) {
        lblTitle.text    = viewModel.textTitle
        lblLanguage.text = viewModel.textLanguage
        accessoryType    = viewModel.accessoryType
    }
}
