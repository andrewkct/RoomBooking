//
//  TimePickerView.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 5/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import UIKit

protocol TimePickerViewDelegate: class {
    func timePickerDidSelect(date: Date)
}

class TimePickerView: UIView {
    @IBOutlet private weak var btnDone: UIButton!
    @IBOutlet private weak var timePicker: UIPickerView!
    
    weak var delegate: TimePickerViewDelegate!
    private(set) var selectedTimeslot: Observable<String> = Observable("")
    private var timeslots: [[String]] = []
    private var date = Date().toLocal()
    private var timeslot = ""
    
    init(frame: CGRect = .zero, timeslots: [[String]], date: Date, timeslot: String, delegate: TimePickerViewDelegate) {
        
        super.init(frame: frame)
        configureXib()
        
        self.frame.size.height = 230
        self.clipsToBounds = true
        self.layer.cornerRadius = 10.0
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        
        self.timeslots = timeslots
        self.date = date
        self.timeslot = timeslot
        self.delegate = delegate
        
        setDisplayTimeslot()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureXib()
    }
    
    private func configureXib() {
        // Load view from nib
        let bundle = Bundle(for: TimePickerView.self)
        let nib = UINib(nibName: String(describing: TimePickerView.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        // Use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view
        addSubview(view)
    }
    
    func set(date: Date) {
        self.date = date
    }
    
    @IBAction private func doneAction(_ sender: Any?) {
        setDisplayTimeslot()
        date = date.transformBy(time: timeslot)
        delegate?.timePickerDidSelect(date: date)
    }
    
    private func setDisplayTimeslot() {
        selectedTimeslot.value = timeslot
    }
}

extension TimePickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return timeslots.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeslots[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeslots[component][row]
    }
}

extension TimePickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let time = timeslots[0][timePicker.selectedRow(inComponent: 0)]
        let ampm = timeslots[1][timePicker.selectedRow(inComponent: 1)]
        
        timeslot = "\(time) \(ampm)"
    }
}
