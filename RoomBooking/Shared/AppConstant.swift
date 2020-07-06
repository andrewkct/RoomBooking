//
//  AppConstant.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 5/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

struct AppConstant {
    // Api
    static let baseUrl = "https://gist.githubusercontent.com"
    static let roomListEndpoint = "/yuhong90/7ff8d4ebad6f759fcc10cc6abdda85cf/raw/463627e7d2c7ac31070ef409d29ed3439f7406f6/room-availability.json"
    
    enum Text {
        static let ok = "OK"
        static let cancel = "Cancel"
        static let retry = "Retry"
    }
}
