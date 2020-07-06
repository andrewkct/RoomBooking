//
//  ApiRouter.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

enum ApiRouterType {
    case roomList(endpoint: String)
}

struct ApiRouter: RequestProtocol {
    private let type: ApiRouterType
    
    init(_ type: ApiRouterType) {
        self.type = type
    }
    
    var baseUrl: String {
        switch self.type {
        default:
            return AppConstant.baseUrl
        }
    }
    
    var path: String {
        switch self.type {
        case .roomList(let endpoint):
            return endpoint
        }
    }
    
    var method: RequestMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var headers: RequestHeaders? {
        return nil
    }
    
    var parameters: RequestParameters? {
        switch self.type {
        default:
            return nil
        }
    }
    
    var requestType: RequestType {
        switch self.type {
        default:
            return .json
        }
    }
}
