//
//  HomeViewController.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 5/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var navigationView: CustomNavigationView!
    @IBOutlet weak var dateView: CustomTextField!
    @IBOutlet weak var timeView: CustomTextField!
    @IBOutlet weak var imgViewSort: UIImageView!
    @IBOutlet weak var tblRoom: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblMessage: UILabel!
    private var datePickerView: DatePickerView?
    private var timePickerView: TimePickerView?
    
    private let roomTableViewCellId = String(describing: RoomTableViewCell.self)
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setObervations()
        
        viewModel.load()
    }
    
    private func configureView() {
        navigationView.set(title: viewModel.navigationTitle, enableCameraButton: true, delegate: self)
        
        hideKeyboardWhenTappedAround()
        
        datePickerView = DatePickerView(timeslot: viewModel.timeslot, delegate: self)
        
        timePickerView = TimePickerView(timeslots: viewModel.timeslots, date: viewModel.date, timeslot: viewModel.timeslot, delegate: self)
        
        dateView.set(title: viewModel.dateTitle)
        dateView.setTextField(inputView: datePickerView)
        
        timeView.set(title: viewModel.timeslotTitle)
        timeView.setTextField(inputView: timePickerView)
        
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle != .light {
                imgViewSort.image = imgViewSort.image?.withRenderingMode(.alwaysTemplate)
                imgViewSort.tintColor = UIColor.white
            }
        }
        
        let rtvcNib = UINib(nibName: roomTableViewCellId, bundle: nil)
        tblRoom.register(rtvcNib, forCellReuseIdentifier: roomTableViewCellId)
    }
    
    private func setObervations() {
        datePickerView?.selectedDate.observe(on: self) { [weak self] (ordinalDate) in
            self?.dateView.setTextField(value: ordinalDate ?? "")
        }
        
        timePickerView?.selectedTimeslot.observe(on: self, completion: { [weak self] (timeslot) in
            
            if let timeslot = timeslot {
                self?.timeView.setTextField(value: timeslot)
                self?.datePickerView?.set(timeslot: timeslot)
            }
        })
        
        viewModel.data.observe(on: self) { [weak self] (data) in
            self?.tblRoom.reloadData()
            self?.lblMessage.isHidden = true
            
            if let data = data, data.count == 0 {
                let noRecord = self?.viewModel.noRecordsText ?? "No records"
                self?.lblMessage.text = noRecord
                self?.lblMessage.isHidden = false
            
            } else {
                DispatchQueue.main.async {
                    self?.tblRoom.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            }
        }
        
        viewModel.loading.observe(on: self) { [weak self] (isLoading) in
            let isLoading = isLoading ?? false
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
        
        viewModel.errorMessage.observe(on: self) { [weak self] (errorMessage) in
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                let okText = self?.viewModel.okText ?? "OK"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.showAlert(message: errorMessage, actionCompletion: {
                        self?.viewModel.load()
                    }, cancelTitle: okText)
                }
            }
        }
    }
    
    @IBAction func sortAction(_ sender: Any) {
        let sortViewModel = SortViewModel(viewModel.sortingTypes)
        let vc = SortViewController(sortViewModel, delegate: self)
        
        // Delay the capture of snapshot by 0.1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {
            vc.snapshotImage = self.view.asImage()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        })
    }
}

extension HomeViewController: CustomNavigationViewDelegate {
    func didSelectCamera() {
        let permissionHelper = PermissionHelper()
        permissionHelper.evaluateCamera { [weak self] (errorMessage) in
            if let errorMessage = errorMessage {
                let okText = self?.viewModel.okText ?? "OK"
                self?.showAlert(message: errorMessage, actionTitle: "", cancelTitle: okText)
                return
            }
            
            DispatchQueue.main.async {
                let scanQRViewModel = ScanQRViewModel()
                let vc = ScanQRViewController(scanQRViewModel)
                let navCtrl = UINavigationController(rootViewController: vc)
                navCtrl.modalPresentationStyle = .fullScreen
                self?.present(navCtrl, animated: true, completion: nil)
            }
        }
    }
}

extension HomeViewController: DatePickerViewDelegate {
    func datePickerDidSelect(date: Date) {
        view.endEditing(true)
        timePickerView?.set(date: date)
        viewModel.set(date: date)
    }
}

extension HomeViewController: TimePickerViewDelegate {
    func timePickerDidSelect(date: Date) {
        view.endEditing(true)
        viewModel.set(date: date)
    }
}

extension HomeViewController: SortViewControllerDelegate {
    func didApplySorting(type: String?) {
        viewModel.sortBy(type: type)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: roomTableViewCellId, for: indexPath) as? RoomTableViewCell else {
            return UITableViewCell()
        }
        
        cell.set(viewModel.data.value[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
