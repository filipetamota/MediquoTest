//
//  NetworkCell.swift
//  MediQuoTest
//
//  Created by Filipe on 07/03/2020.
//  Copyright © 2020 Filipe Mota. All rights reserved.
//

import UIKit

class NetworkCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(viewModel: Home.Fetch.ViewModel) {
        titleLabel.text = viewModel.name
        locationLabel.text = "\(viewModel.location.city), \(viewModel.location.country)"
    }
    
}
