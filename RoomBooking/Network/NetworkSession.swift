//
//  NetworkSession.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

// Class handling the creation of URLSessionTaks and
// responding to URSessionDelegate callbacks
final class NetworkSession: NSObject {
    private var session: URLSession!

    // Convenience initializer
    override convenience init() {
        // Configure the default URLSessionConfiguration
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 30
        
        if #available(iOS 11, *) {
            sessionConfiguration.waitsForConnectivity = true
        }
        
        // Call the designated initializer
        self.init(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
    }

    // Designated initializer
    init(configuration: URLSessionConfiguration, delegate: URLSessionDelegate?, delegateQueue: OperationQueue?) {
        
        super.init()
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: delegateQueue)
    }

    deinit {
        // We have to invalidate the session because
        // URLSession strongly retains its delegate
        // Ref: https://developer.apple.com/documentation/foundation/urlsession/1411538-invalidateandcancel
        session.finishTasksAndInvalidate()
        session = nil
    }
    
}


extension NetworkSession: NetworkSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        
        return session.dataTask(with: request, completionHandler: completionHandler)
    }
}
