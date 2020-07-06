//
//  ResponseHandler.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

// Class that handles the response of a request
final class ResponseHandler: ResponseHandlerProtocol {
    private let requestType: RequestType
    
    required init(requestType: RequestType) {
        self.requestType = requestType
    }
    
    func handle<T: Codable>(responseData: Data?, urlResponse: URLResponse?, error: Error?, completion: @escaping (ResponseResult<T>) -> Void) {
        
        // Check if the response is valid
        guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
            DispatchQueue.main.async {
                completion(.error(ApiError.invalidResponse, urlResponse as? HTTPURLResponse))
            }
            return
        }
        
        // Verify the HTTP status code
        let result = verify(data: responseData, httpUrlResponse: httpUrlResponse, error: error)
        
        switch result {
        case .success (let data):
            guard let data = data as? Data else {
                DispatchQueue.main.async {
                    completion(.error(ApiError.invalidResponse, httpUrlResponse))
                }
                return
            }
            
            // Determine the type of response
            determineResponse(with: data, httpUrlResponse: httpUrlResponse, error: error, completion: completion)
            
        case .failure (let error):
            DispatchQueue.main.async {
                completion(.error(error, httpUrlResponse))
            }
        }
    }
}


extension ResponseHandler {
    private func verify(data: Any?, httpUrlResponse: HTTPURLResponse, error: Error?) -> Result<Any, Error> {
        
        switch httpUrlResponse.statusCode {
        case 200...299:
            if let data = data {
                return .success(data)
            } else {
                return .failure(ApiError.noData)
            }
            
        case 400...499:
            return .failure(ApiError.badRequest(error?.localizedDescription ?? ""))
        
        case 500...599:
            return .failure(ApiError.serverError(error?.localizedDescription ?? ""))
        
        default:
            return .failure(ApiError.unknown(error?.localizedDescription ?? ""))
        }
    }
    
    private func determineResponse<T: Codable>(with data: Data, httpUrlResponse: HTTPURLResponse, error: Error?, completion: @escaping (ResponseResult<T>) -> Void) {
        
        switch requestType {
        case .plainText:
            handlePlainTextResponse(data: data, httpUrlResponse: httpUrlResponse, error: error, completion: completion)
            
        case .json:
            handleJsonResponse(data: data, httpUrlResponse: httpUrlResponse, error: error, completion: completion)
            
        case .download: break
        case .upload: break
        }
    }
}


extension ResponseHandler {
    private func handlePlainTextResponse<T>(data: Data, httpUrlResponse: HTTPURLResponse, error: Error?, completion: @escaping (ResponseResult<T>) -> Void) {
        
        let strData = String(decoding: data, as: UTF8.self)
        
        DispatchQueue.main.async {
            completion(.success(strData as! T, httpUrlResponse))
        }
    }
    
    private func handleJsonResponse<T: Decodable>(data: Data, httpUrlResponse: HTTPURLResponse?, error: Error?, completion: @escaping (ResponseResult<T>) -> Void) {
        
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(T.self, from: data)
            
            DispatchQueue.main.async {
                completion(.success(model, httpUrlResponse))
            }
        
        } catch (let exception) {
            DispatchQueue.main.async {
                completion(.error(ApiError.parseError(exception.localizedDescription), httpUrlResponse))
            }
        }
    }
}
