//
//  CameraViewControllerPresenter.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/26.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

protocol CameraViewControllerDelegate: class {
    func hideLoadingScene()
    func prepare(result: String)
    func showAlert()
}

class CameraViewControllerPresenter {
    
    private let viewControllerModel = ViewControllerModel()
    
    weak var delegate: CameraViewControllerDelegate?
    
    func photoOutput(imageData: Data) {
        viewControllerModel.request(imageData: imageData) { result in
            DispatchQueue.main.async {
                // FIXME: 遷移時にカメラ画面が表示されるので、消すタイミング要修正
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
