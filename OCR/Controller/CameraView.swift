//
//  CameraView.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/03.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CameraView: UIViewController, NVActivityIndicatorViewable {
    
    private let cameraViewControllerPresenter = CameraViewPresenter()
    private var photoOutputGenerator: PhotoOutputGenerator?
    
    @IBOutlet var takePhotoButton: UIButton!
    @IBOutlet var screenshotImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraViewControllerPresenter.delegate = self
        photoOutputGenerator = PhotoOutputGenerator.create(frame: screenshotImageView.frame, takePhotoHandler: { [weak self] imageData in
            guard let weakSelf = self else { return }
            guard let imageData = imageData else {
                weakSelf.showAlert(title: "画像取得に失敗しました", message: "再度お試しください。")
                weakSelf.takePhotoButton.isEnabled = true
                return
            }
            weakSelf.showLoadingScene(imageData: imageData)
            weakSelf.photoOutput(imageData: imageData)
        })
        
        if let cameraPreviewLayer = photoOutputGenerator?.generateCameraPreviewLayer(frame: screenshotImageView.frame) {
            self.view.layer.insertSublayer(cameraPreviewLayer, at: 0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecognitionResultView" {
            let recognitionResultView = segue.destination as? RecognitionResultView
            recognitionResultView?.resultText = sender as? String ?? ""
        }
    }
    
    @IBAction func tapTakePhotoButton(_ sender: Any) {
        takePhotoButton.isEnabled = false
        photoOutputGenerator?.takePhoto()
    }
    
    private func showLoadingScene(imageData: Data) {
        self.startAnimating(message: "文字認識中...", type: .pacman)
        screenshotImageView.image = UIImage(data: imageData)
        screenshotImageView.isHidden = false
        self.view.bringSubviewToFront(takePhotoButton)
    }
    
    private func photoOutput(imageData: Data) {
        self.cameraViewControllerPresenter.photoOutput(imageData: imageData)
    }
    
}

extension CameraView: CameraViewPresenterDelegate {
    
    func hideLoadingScene() {
        self.stopAnimating()
        self.screenshotImageView.isHidden = true
        self.takePhotoButton.isEnabled = true
    }
    
    func prepare(result: String) {
        self.performSegue(withIdentifier: "toRecognitionResultView", sender: result)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
