//
//  Observer.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 5/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

struct Observer<T> {
    typealias CompletionHandler = (T?) -> Void
    weak var observer: AnyObject?
    let completion: CompletionHandler
}
