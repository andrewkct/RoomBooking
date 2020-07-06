//
//  ResultViewController.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import UIKit
import WebKit

class ResultViewController: UIViewController {
    @IBOutlet weak var navigationView: CustomNavigationView!
    @IBOutlet weak var resultWebView: WKWebView!
    @IBOutlet weak var btnBackToHome: CustomButton!
    
    var viewModel: ResultViewModel!
    
    init(_ viewModel: ResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setObservations()
        viewModel.load()
    }
    
    deinit {
        resultWebView.scrollView.delegate = nil
    }
    
    private func configureView() {
        navigationView.set(title: viewModel.navigationTitle, enableBackButton: true, delegate: self)
        
        resultWebView.backgroundColor = .clear
        resultWebView.scrollView.isScrollEnabled = false
        resultWebView.scrollView.isUserInteractionEnabled = false
    }
    
    private func setObservations() {
        viewModel.data.observe(on: self) { [weak self] (htmlStr) in
            if let htmlStr = htmlStr, !htmlStr.isEmpty {
                self?.resultWebView.loadHTMLString(htmlStr, baseURL: nil)
            }
        }
        
        viewModel.errorMessage.observe(on: self) { [weak self] (errorMessage) in
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                let okText = self?.viewModel.okText ?? "OK"
                
                self?.showAlert(message: errorMessage, actionTitle: "", cancelTitle: okText, cancelCompletion: {
                    self?.didSelectBack()
                })
            }
        }
    }
    
    @IBAction func backToHomeAction(_ sender: Any?) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension ResultViewController: CustomNavigationViewDelegate {
    func didSelectBack() {
        navigationController?.popViewController(animated: true)
    }
}
