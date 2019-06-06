//
//  ResultViewControllerPresenter.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/25.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

protocol ResultViewPresenterDelegate: class {
    func closeResultView()
    func showAlert()
}

class ResultViewControllerPresenter {
    
    private let viewControllerModel = ViewControllerModel()
    
    weak var delegate: ResultViewPresenterDelegate?
    
    func tapSaveButton(titleText: String?, resultText: String) {
        guard let titleText = titleText else { return }
        if titleText == "" {
            delegate?.showAlert()
        } else {
            viewControllerModel.insert(titleText: titleText, resultText: resultText)
            delegate?.closeResultView()
        }
    }
    
}
