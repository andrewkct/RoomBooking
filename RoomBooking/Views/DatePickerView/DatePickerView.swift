//
//  DatePickerView.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 5/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import UIKit

protocol DatePickerViewDelegate: class {
    func datePickerDidSelect(date: Date)
}

class DatePickerView: UIView {
    @IBOutlet private weak var btnDone: UIButton!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    weak var delegate: DatePickerViewDelegate!
    private(set) var selectedDate: Observable<String> = Observable("")
    private var timeslot = ""
    
    init(frame: CGRect = .zero, timeslot: String, delegate: DatePickerViewDelegate) {
        
        super.init(frame: frame)
        configureXib()
        
        self.frame.size.height = 230
        self.clipsToBounds = true
        self.layer.cornerRadius = 10.0
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.datePicker.datePickerMode = .date
        self.datePicker.timeZone = TimeZone(abbreviation: "UTC")
        self.datePicker.date = Date().toLocal()
        
        self.timeslot = timeslot
        self.delegate = delegate
        
        setDisplayDate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureXib()
    }
    
    private func configureXib() {
        // Load view from nib
        let bundle = Bundle(for: DatePickerView.self)
        let nib = UINib(nibName: String(describing: DatePickerView.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        // Use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view
        addSubview(view)
    }

    func set(timeslot: String) {
        self.timeslot = timeslot
        datePicker.date = datePicker.date.transformBy(time: timeslot)
    }

    @IBAction private func doneAction(_ sender: Any?) {
        setDisplayDate()
        delegate?.datePickerDidSelect(date: datePicker.date)
    }
    
    private func setDisplayDate() {
        selectedDate.value = datePicker.date.toOrdinal()
    }
}
