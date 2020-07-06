//
//  RequestDispatcher.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

// Class that handles the dispatch of a request
// with a given configuration
final class RequestDispatcher: RequestDispatcherProtocol {
    // URLSessionConfiguration
    private var networkSession: NetworkSessionProtocol
    
    required init(networkSession: NetworkSessionProtocol) {
        self.networkSession = networkSession
    }
    
    func execute<T: Codable>(request: RequestProtocol, completion: @escaping (ResponseResult<T>) -> Void) -> URLSessionTask? {
        
        guard var urlRequest = request.createUrlRequest() else {
            completion(.error(ApiError.badRequest("Invalid URL for: \(request)"), nil))
            return nil
        }
        
        // Appends specific headers
        request.headers?.forEach({ (key: String, value: String) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        })
        
        // Creates a response handler according to the request type
        let responseHandler = ResponseHandler(requestType: request.requestType)
        
        // Create a URLSessionTask to execute the URLRequest
        var task: URLSessionTask?
        
        switch request.requestType {
        case .json, .plainText:

            task = networkSession.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
                
                responseHandler.handle(responseData: data, urlResponse: urlResponse, error: error, completion: completion)
            })
            
        case .download: break
        case .upload: break
        }
        
        // Start the task
        task?.resume()
        
        return task
    }
}
