//
//  RoomResponse.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

struct RoomResponse: Codable {
    let name: String
    let capacity: String
    let level: String
    let availability: [String: String]
}
