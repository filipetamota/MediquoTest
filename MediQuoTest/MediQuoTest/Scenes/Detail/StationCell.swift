//
//  StationCell.swift
//  MediQuoTest
//
//  Created by Filipe on 07/03/2020.
//  Copyright © 2020 Filipe Mota. All rights reserved.
//

import UIKit

class StationCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondaryTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(viewModel: Detail.Fetch.Station) {
        titleLabel.text = viewModel.name
        secondaryTitleLabel.text = "Free Bikes: \(viewModel.freeBikes), Empty Slots: \(viewModel.emptySlots)"
    }
    
}
