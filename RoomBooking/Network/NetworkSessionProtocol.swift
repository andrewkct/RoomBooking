//
//  NetworkSessionProtocol.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

// Protocol to which network session handling classes must conform to
protocol NetworkSessionProtocol {
    // Create a URLSessionDataTask
    // The caller is responsible for calling resume()
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask?
}
