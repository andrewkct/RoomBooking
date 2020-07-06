//
//  PermissionHelper.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation
import AVFoundation

typealias evaluateCameraBlock = (String?) -> Void

class PermissionHelper {
    func evaluateCamera(completion: @escaping evaluateCameraBlock) {
        var errorMessage = String(format: "Please enable access to your camera in Settings.\nGo to Privacy > Camera > %@", Bundle.main.displayName ?? "")
        
        guard checkCameraPlistIsAdded() else {
            errorMessage = "Please make sure Camera Access is set in your app Info.plist."
            completion(errorMessage)
            return
        }
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case AVAuthorizationStatus.authorized:
            completion(nil)
            
        case AVAuthorizationStatus.denied:
            completion(errorMessage)
            
        case AVAuthorizationStatus.restricted:
            completion(errorMessage)
            
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    completion(nil)
                } else {
                    completion(errorMessage)
                }
            }
            
        default:
            completion(errorMessage)
        }
    }
    
    private func checkCameraPlistIsAdded() -> Bool {
        let dictionary = Bundle.main.infoDictionary!
        let cameraKeyExists = dictionary["NSCameraUsageDescription"] != nil
        return cameraKeyExists
    }
}
