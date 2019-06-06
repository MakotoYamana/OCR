//
//  CameraViewControllerPresenter.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/26.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

protocol CameraViewPresenterDelegate: class {
    func hideLoadingScene()
    func prepare(result: String)
    func showAlert()
}

class CameraViewControllerPresenter {
    
    private let viewControllerModel = ViewControllerModel()
    
    weak var delegate: CameraViewPresenterDelegate?
    
    func photoOutput(imageData: Data) {
        viewControllerModel.request(imageData: imageData) { result in
            DispatchQueue.main.async {
                self.delegate?.hideLoadingScene()
                guard result == "null" else {
                    self.delegate?.prepare(result: result)
                    return
                }
                self.delegate?.showAlert()
            }
        }
    }
    
}
