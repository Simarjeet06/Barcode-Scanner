//
//  ScannerVC.swift
//  Barcode Scanner
//
//  Created by Simarjeet Kaur on 30/04/25.
//

import UIKit
import AVFoundation

enum CameraError:String{
    case invalidDeviceInput="Something is wrong with the camera.we're unable to capture the input."
    case invalidScannedValue="The value scanned is not valid.This app scans only EAN-8,qr and EAN-13."
}
protocol ScannerVCDelegate: AnyObject{
    func didFind(barcode:String)
    func didSurfaceError(error:CameraError)
}
final class ScannerVC:UIViewController{
    
    let captureSession=AVCaptureSession()
    var previewLayer:AVCaptureVideoPreviewLayer?
    weak var scanDelegate: ScannerVCDelegate?
    init(scanDelegate:ScannerVCDelegate){
        super.init(nibName: nil, bundle: nil)
        self.scanDelegate=scanDelegate
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let previewLayer=previewLayer else{
            scanDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame=view.layer.bounds
    }
    private func setupCaptureSession(){
        guard let videoCaptureDevice=AVCaptureDevice.default(for: .video)
        else{
            scanDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return
        }
        let videoInput:AVCaptureDeviceInput
        do{
            try videoInput=AVCaptureDeviceInput(device:videoCaptureDevice)
        }catch{
            scanDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return
        }
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }
        else{
            scanDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return
        }
        let metaDataOutput=AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metaDataOutput){
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes=[.ean13,.ean8,.qr]
        }
        else{
            scanDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return
        }
        previewLayer=AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        captureSession.startRunning()
        
        
    }
}
extension ScannerVC:AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object=metadataObjects.first
        else{
            scanDelegate?.didSurfaceError(error: .invalidScannedValue)
            return
        }
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject
        else{
            scanDelegate?.didSurfaceError(error: .invalidScannedValue)
            return
        }
        guard  let barcode=machineReadableObject.stringValue else{
            scanDelegate?.didSurfaceError(error: .invalidScannedValue)
            return
        }
        scanDelegate?.didFind(barcode: barcode)
    }
}
