//
//  ServiceProtocol.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

// Protocol to which a service class must conform to
protocol ServiceProtocol {
    typealias Completion<T> = (ResponseResult<T>) -> Void
    
    // Required initializer
    init(session: NetworkSession)
}

extension ServiceProtocol {
    func isConnected() -> Bool {
        return Connectivity.isConnectedToNetwork()
    }
}
