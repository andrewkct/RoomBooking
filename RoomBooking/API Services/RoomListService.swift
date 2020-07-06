//
//  RoomListService.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

class RoomListService: ServiceProtocol {
    private var session: NetworkSession
    
    required init(session: NetworkSession) {
        self.session = session
    }
    
    func getRoomList(completion: @escaping Completion<[RoomResponse]>) -> URLSessionTask? {
        if !isConnected() {
            completion(.error(ApiError.noConnection, nil))
            return nil
        }
        
        let endPoint = AppConstant.roomListEndpoint
        let api = ApiRouter(.roomList(endpoint: endPoint))
        
        let dispatcher = RequestDispatcher(networkSession: session)
        return dispatcher.execute(request: api) { (result: ResponseResult<[RoomResponse]>) in
            completion(result)
        }
    }
}

