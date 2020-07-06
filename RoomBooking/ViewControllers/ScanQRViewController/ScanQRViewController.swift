//
//  ScanQRViewController.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRViewController: UIViewController {
    @IBOutlet weak var navigationView: CustomNavigationView!
    @IBOutlet private weak var scannerView: UIView!
    @IBOutlet private weak var imgViewScanOverLayer: UIImageView!
    private var captureSession: AVCaptureSession?
    
    var viewModel: ScanQRViewModel!
    private var scannedCode: String = ""
    
    init(_ viewModel: ScanQRViewModel) {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startReading()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopReading()
    }
    
    private func configureView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationView.set(title: viewModel.navigationTitle, enableBackButton: true, delegate: self)
        
        initScannerView()
    }
    
    private func setObservations() {
        viewModel.data.observe(on: self, completion: { [weak self] (decodedQr) in
            if let decodedQr = decodedQr, !decodedQr.isEmpty {
                let resultViewModel = ResultViewModel(decodedQr)
                self?.navigateToWebView(resultViewModel)
            }
        })
        
        viewModel.errorMessage.observe(on: self) { [weak self] (errorMessage) in
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                let cancelText = self?.viewModel.cancelText ?? "Cancel"
                
                self?.showAlert(message: errorMessage, actionCompletion: {
                    self?.startReading()
                    
                }, cancelTitle: cancelText, cancelCompletion: {
                    self?.didSelectBack()
                })
            }
        }
    }

    private func initScannerView() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showErrorSetupScan()
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        
        } catch {
            showErrorSetupScan()
            return
        }
        
        let canAddInput = captureSession?.canAddInput(videoInput) ?? false
        let metadataOutput = AVCaptureMetadataOutput()
        let canAddOutput = captureSession?.canAddOutput(metadataOutput) ?? false
        
        if canAddInput && canAddOutput {
            captureSession?.addInput(videoInput)
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            
        } else {
            showErrorSetupScan()
            return
        }
        
        guard let session = captureSession else {
            showErrorSetupScan()
            return
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scannerView.layer.addSublayer(previewLayer)
    }
    
    private func showErrorSetupScan() {
        showAlert(message: viewModel.qrSetupError, actionTitle: "", cancelTitle: viewModel.okText) {
            self.didSelectBack()
        }
    }
    
    private func startReading() {
        if captureSession?.isRunning == false {
            captureSession?.startRunning()
        }
    }
    
    private func stopReading() {
        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
    }
    
    private func handleCapture(code: String, scanType: AVMetadataObject.ObjectType) {
        viewModel.verifyQR(code: code, scanType: scanType)
    }
    
    private func navigateToWebView(_ resultViewModel: ResultViewModel) {
        let vc = ResultViewController(resultViewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ScanQRViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        stopReading()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            
            guard let stringValue = readableObject.stringValue else {
                return
            }
            
            // Handle captured string
            handleCapture(code: stringValue, scanType: metadataObject.type)
        }
    }
}

extension ScanQRViewController: CustomNavigationViewDelegate {
    func didSelectBack() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
