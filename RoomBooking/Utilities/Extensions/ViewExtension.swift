//
//  ViewExtension.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import UIKit

extension UIView  {
    // Render the view within the view's bounds, then capture it as image
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
    
        return renderer.image(actions: { rendererContext in
            layer.render(in: rendererContext.cgContext)
        })
    }
}
