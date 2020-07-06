//
//  CustomNavigationView.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 5/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import UIKit

protocol CustomNavigationViewDelegate: class {
    func didSelectBack()
    func didSelectCamera()
}

extension CustomNavigationViewDelegate {
    func didSelectBack() {}
    func didSelectCamera() {}
}

@IBDesignable
class CustomNavigationView: UIView {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnBackWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCameraWidthConstraint: NSLayoutConstraint!
    
    weak var delegate: CustomNavigationViewDelegate?
    private let btnSizeWidth: CGFloat = 45
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureXib()
    }
    
    private func configureXib() {
        // Load view from nib
        let bundle = Bundle(for: CustomNavigationView.self)
        let nib = UINib(nibName: String(describing: CustomNavigationView.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        // Use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view
        addSubview(view)
    }
    
    func set(title: String, enableBackButton: Bool = false, enableCameraButton: Bool = false, delegate: CustomNavigationViewDelegate?) {
        
        lblTitle.text = title
        self.delegate = delegate
        
        if !enableBackButton {
            btnBack.isEnabled = false
            btnBack.isHidden = true
        }
        
        if !enableCameraButton {
            btnCamera.isEnabled = false
            btnCamera.isHidden = true
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        delegate?.didSelectBack()
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        delegate?.didSelectCamera()
    }
}
