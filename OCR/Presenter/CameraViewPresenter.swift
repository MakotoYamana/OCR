//
//  CameraViewPresenter.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/26.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

protocol CameraViewPresenterDelegate: class {
    func hideLoadingScene()
    func prepare(result: String)
    func showAlert(title: String, message: String)
}

class CameraViewPresenter {
    
    private let ocrModel = OCRModel.shared
    
    weak var delegate: CameraViewPresenterDelegate?
    
    func photoOutput(imageData: Data) {
        ocrModel.request(imageData: imageData) { result in
            DispatchQueue.main.async {
                self.delegate?.hideLoadingScene()
                if result == "null" {
                    self.delegate?.showAlert(title: "文字認識に失敗しました", message: "再度お試しください。")
                } else if result == "The Internet connection appears to be offline." {
                    self.delegate?.showAlert(title: "ネットワークエラーが発生しました", message: "オフラインを解除した上で、再度お試しください。")
                } else {
                    self.delegate?.prepare(result: result)
                }
            }
        }
    }
    
}
