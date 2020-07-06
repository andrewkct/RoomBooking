//
//  NetworkConstant.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

typealias RequestHeaders = [String: String]
typealias RequestParameters = [String : Any?]

enum RequestType {
    /// Translate to a URLSessionDataTask
    case json, plainText
    /// Translate to a URLSessionDownloadTask
    case download
    /// Translate to a URLSessionUploadTask
    case upload
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum ResponseResult<T> {
    case success(T, _ response: HTTPURLResponse?)
    case error(Error, _ response: HTTPURLResponse?)
}

enum ApiError: Error {
    /// No internet connection
    case noConnection
    /// No data received from the server
    case noData
    /// The server response was invalid (unexpected format)
    case invalidResponse
    /// The request was rejected: 400-499
    case badRequest(String?)
    /// Encoutered a server error
    case serverError(String?)
    /// There was an error parsing the data
    case parseError(String?)
    /// Unknown error
    case unknown(String?)
}
