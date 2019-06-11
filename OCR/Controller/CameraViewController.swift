//
//  CameraViewController.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/03.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CameraViewController: UIViewController, NVActivityIndicatorViewable {
    
    private let cameraViewControllerPresenter = CameraViewControllerPresenter()
    // TODO: 役割に合わせたクラス名に変更
    private var cameraViewSetting: CameraViewSetting?
    
    @IBOutlet var takePhotoButton: UIButton!
    @IBOutlet var screenshotImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraViewControllerPresenter.delegate = self
        cameraViewSetting = CameraViewSetting.create(frame: screenshotImageView.frame, takePhotoHandler: { [weak self] imageData in
            guard let self = self,
                let imageData = imageData else {
                    print("画像取得に失敗")
                    return
            }
            self.showLoadingScene(imageData: imageData)
            self.photoOutput(imageData: imageData)
        })
        
        if let cameraPreviewLayer = cameraViewSetting?.generateCameraPreviewLayer(frame: screenshotImageView.frame) {
            self.view.layer.insertSublayer(cameraPreviewLayer, at: 0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultViewController" {
            let resultViewController = segue.destination as? ResultViewController
            resultViewController?.resultText = sender as? String ?? ""
        }
    }
    
    @IBAction func tapTakePhotoButton(_ sender: Any) {
        takePhotoButton.isEnabled = false
        cameraViewSetting?.takePhoto()
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

extension CameraViewController: CameraViewPresenterDelegate {
    
    func hideLoadingScene() {
        self.stopAnimating()
        self.screenshotImageView.isHidden = true
        self.takePhotoButton.isEnabled = true
    }
    
    func prepare(result: String) {
        self.performSegue(withIdentifier: "toResultViewController", sender: result)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
