//
//  RequestDispatcherProtocol.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

// Protocol to which a request dispatcher class must conform to
protocol RequestDispatcherProtocol {
    // Required initializer
    init(networkSession: NetworkSessionProtocol)

    // Executes a request
    func execute<T: Codable>(request: RequestProtocol, completion: @escaping (ResponseResult<T>) -> Void) -> URLSessionTask?
}
