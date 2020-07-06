//
//  ResponseHandlerProtocol.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

// Protocol to which a response handler class must conform to
protocol ResponseHandlerProtocol {
    // Required initializer
    init(requestType: RequestType)
    
    // Handle a response
    func handle<T: Codable>(responseData: Data?, urlResponse: URLResponse?, error: Error?, completion: @escaping (ResponseResult<T>) -> Void)
}
