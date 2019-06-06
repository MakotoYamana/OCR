//
//  CameraViewController.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/03.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView

class CameraViewController: UIViewController, NVActivityIndicatorViewable {
    
    private let cameraViewControllerPresenter = CameraViewControllerPresenter()
    
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet var takePhotoButton: UIButton!
    @IBOutlet var screenshotImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraViewControllerPresenter.delegate = self
        setupCaptureSession()
        setupDevice()
        setupInputAndOutput()
        setupPreviewLayer()
        captureSession.startRunning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultViewController" {
            let resultViewController = segue.destination as? ResultViewController
            resultViewController?.resultText = sender as? String ?? ""
        }
    }
    
    @IBAction func tapTakePhotoButton(_ sender: Any) {
        takePhotoButton.isEnabled = false
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        settings.isAutoStillImageStabilizationEnabled = true
        photoOutput?.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
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
    private func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        guard let cameraPreviewLayer = cameraPreviewLayer else { return }
        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer.frame = screenshotImageView.frame
        self.view.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    private func showLoadingScene(imageData: Data) {
        self.startAnimating(message: "文字認識中...", type: .pacman)
        screenshotImageView.image = UIImage(data: imageData)
        screenshotImageView.isHidden = false
        self.view.bringSubviewToFront(takePhotoButton)
    }
    
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        self.showLoadingScene(imageData: imageData)
        self.cameraViewControllerPresenter.photoOutput(imageData: imageData)
    }
    
}

extension CameraViewController: CameraViewPresenterDelegate {
    
    func hideLoadingScene() {
        self.stopAnimating()
        self.screenshotImageView.isHidden = true
        self.takePhotoButton.isEnabled = true
    }
    
    func prepare(result: String) {
        self.performSegue(withIdentifier: "toResultViewController", sender: result)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "文字認識に失敗しました", message: "再度お試しください。", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
