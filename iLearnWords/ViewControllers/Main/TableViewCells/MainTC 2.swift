//
//  MainTBC.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import UIKit

class MainTC: UITableViewCell {

    // MARK: - Type Properties
    static let reuseIdentifier = "CellMain"

    // MARK: - Outlets
    @IBOutlet weak var lblOriginal: UILabel!
    @IBOutlet weak var lblTranslated: UILabel!
    
    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        // Configure Cell
        selectionStyle = .none
    }

    // MARK: - Configuration

    func configure(withViewModel viewModel: MainRepresentable) {
        lblOriginal.text   = viewModel.textOriginal
        lblTranslated.text = viewModel.textTranslated
    }
}

