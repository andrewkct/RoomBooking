//
//  RoomTableViewModel.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import UIKit

class RoomTableViewModel {
    private(set) var nameText: String = ""
    private(set) var levelText: String = ""
    private(set) var paxText: String = ""
    private(set) var availableText: String = ""
    private(set) var availableTextColor: UIColor = .red
    
    private var room: Room
    
    init(_ room: Room) {
        self.room = room
        
        nameText = room.name
        levelText = "Level \(room.level)"
        paxText = "\(room.capacity) Pax"
        
        if room.isAvailable {
            availableText = "Available"
            availableTextColor = UIColor(red: 138/255, green: 205/255, blue: 137/255, alpha: 1.0)
        } else {
            availableText = "Not Available"
            availableTextColor = .darkGray
        }
    }
}
