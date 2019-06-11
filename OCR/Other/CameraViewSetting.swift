//
//  CameraViewSetting.swift
//  OCR
//
//  Created by MakotoYamana on 2019/06/08.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import AVFoundation

class CameraViewSetting: NSObject {
    
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    typealias PhotoResultHandler = ((Data?) -> ())
    var takePhotoHandler: PhotoResultHandler?
    
    static func create(frame: CGRect, takePhotoHandler: @escaping PhotoResultHandler) -> CameraViewSetting {
        let cvs = CameraViewSetting.init()
        cvs.takePhotoHandler = takePhotoHandler
        cvs.setup()
        return cvs
    }
    
    func generateCameraPreviewLayer(frame: CGRect) -> AVCaptureVideoPreviewLayer? {
        return setupPreviewLayer(frame: frame)
    }
    
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        settings.isAutoStillImageStabilizationEnabled = true
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    private func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputAndOutput()
        captureSession.startRunning()
    }
    
    /// カメラ画質の設定
    private func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    /// デバイスの設定
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                captureDevice = device
            }
        }
    }
    
    /// 入出力データの設定
    private func setupInputAndOutput() {
        guard let captureDevice = captureDevice else { return }
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            guard let photoOutput = photoOutput else { return }
            photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput)
        } catch {
            print(error)
        }
    }
    
    /// カメラプレビュー表示の設定
    private func setupPreviewLayer(frame: CGRect) -> AVCaptureVideoPreviewLayer? {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        guard let cameraPreviewLayer = cameraPreviewLayer else { return self.cameraPreviewLayer }
        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer.frame = frame
        self.cameraPreviewLayer = cameraPreviewLayer
        return self.cameraPreviewLayer
    }
    
}

extension CameraViewSetting: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        takePhotoHandler?(photo.fileDataRepresentation())
    }
    
}
