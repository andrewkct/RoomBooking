//
//  RoomTableViewCell.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var lblPax: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 7.0
    }
    
    func set(_ viewModel: RoomTableViewModel) {
        lblName.text = viewModel.nameText
        lblLevel.text = viewModel.levelText
        lblAvailable.text = viewModel.availableText
        lblAvailable.textColor = viewModel.availableTextColor
        lblPax.text = viewModel.paxText
    }
}
