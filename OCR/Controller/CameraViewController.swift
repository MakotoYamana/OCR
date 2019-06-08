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
    private let cameraViewSetting = CameraViewSetting()
    
    @IBOutlet var takePhotoButton: UIButton!
    @IBOutlet var screenshotImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraViewControllerPresenter.delegate = self
        cameraViewSetting.setup()
        guard let cameraPreviewLayer = cameraViewSetting.generateCameraPreviewLayer(frame: screenshotImageView.frame) else { return }
        self.view.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultViewController" {
            let resultViewController = segue.destination as? ResultViewController
            resultViewController?.resultText = sender as? String ?? ""
        }
    }
    
    @IBAction func tapTakePhotoButton(_ sender: Any) {
        takePhotoButton.isEnabled = false
        cameraViewSetting.settingPhotoOutput(delegate: self as AVCapturePhotoCaptureDelegate)
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
