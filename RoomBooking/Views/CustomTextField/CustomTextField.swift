//
//  CustomTextField.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 5/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UIView {
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var txtField: UITextField!
    @IBOutlet private weak var separatorView: UIView!
  
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
        let bundle = Bundle(for: CustomTextField.self)
        let nib = UINib(nibName: String(describing: CustomTextField.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        // Use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view
        addSubview(view)
    }
    
    func set(title: String, placeholderTitle: String = "") {
        lblTitle.text = title
        txtField.placeholder = placeholderTitle
    }
    
    func setTextField(inputView: UIView?) {
        txtField.inputView = inputView
    }
    
    func setTextField(value: String) {
        txtField.text = value
    }
}
