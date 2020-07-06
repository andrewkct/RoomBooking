//
//  RequestProtocol.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

// Protocol to which the HTTP requests must conform
protocol RequestProtocol {
    /// Base Url
    var baseUrl: String { get }
    
    /// Endpoint
    var path: String { get }

    /// HTTP method
    var method: RequestMethod { get }

    /// HTTP headers
    var headers: RequestHeaders? { get }

    /// Query parameters for GET requests
    /// HTTP body for POST, PUT and PATCH requests
    var parameters: RequestParameters? { get }
    
    /// Request type
    var requestType: RequestType { get }
}


extension RequestProtocol {
    // Creates a URLRequest
    func createUrlRequest() -> URLRequest? {
        guard let url = createUrl() else {
            return nil
        }
        
        // Creates a request
        var request = URLRequest(url: url)

        // Appends all related properties
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        
        if !requestBody.isEmpty {
            // Appends request body
            request.httpBody = requestBody
        }
        
        return request
    }

    // Creates a url
    private func createUrl() -> URL? {
        // Create a URLComponents
        guard var urlComponents = URLComponents(string: baseUrl) else {
            return nil
        }
        
        //urlComponents.scheme = "https"
        //urlComponents.host = baseUrl
        
        // Appends endpoint path
        urlComponents.path = path
        
        if !queryItems.isEmpty {
            // Appends query items
            urlComponents.queryItems = queryItems
        }
        
        return urlComponents.url
    }

    // Returns URLQueryItems
    private var queryItems: [URLQueryItem] {
        // The query items should be used for GET only
        guard method == .get, let parameters = parameters else {
            return []
        }
        
        // Convert parameters to query items
        return parameters.map({
            URLQueryItem(name: $0, value: String(describing: $1 ?? ""))
        })
    }

    // Returns request body
    private var requestBody: Data {
        // The body data should be used for POST, PUT and PATCH only
        guard [.post, .put, .patch].contains(method), let parameters = parameters else {
            return Data()
        }
        
        // Convert parameters to JSON data
        var jsonBody = Data()
        
        do {
            jsonBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            //TODO: Handle error
            print("Body has error!: error")
        }
        
        return jsonBody
    }
}
