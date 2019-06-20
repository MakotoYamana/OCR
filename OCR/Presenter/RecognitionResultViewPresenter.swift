//
//  RecognitionResultViewPresenter.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/25.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

protocol RecognitionResultViewPresenterModel {
    func insert(titleText: String, resultText: String)
}

protocol RecognitionResultViewPresenterDelegate: class {
    func closeResultView()
    func showAlert()
}

class RecognitionResultViewPresenter {
    
    private var model: RecognitionResultViewPresenterModel?
    
    init(model: RecognitionResultViewPresenterModel) {
        self.model = model
    }
    
    weak var delegate: RecognitionResultViewPresenterDelegate?
    
    func tapSaveButton(titleText: String?, resultText: String) {
        guard let titleText = titleText else { return }
        if titleText == "" {
            delegate?.showAlert()
        } else {
            model?.insert(titleText: titleText, resultText: resultText)
            delegate?.closeResultView()
        }
    }
    
}
