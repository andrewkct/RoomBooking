//
//  SortTableViewModel.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

class SortTableViewModel {
    private var sortItem: SortItem
    private(set) var titleText: String
    private(set) var imgViewName: String
    
    init(_ sortItem: SortItem) {
        self.sortItem = sortItem
        
        titleText = self.sortItem.name
        imgViewName = self.sortItem.isSelected ? "ic_radio_active" : "ic_radio_inactive"
    }
}
