//
//  SortTableViewCell.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import UIKit

class SortTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgViewRadio: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(_ viewModel: SortTableViewModel) {
        lblTitle.text = viewModel.titleText
        imgViewRadio.image = UIImage(named: viewModel.imgViewName)
    }
}
