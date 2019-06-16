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
    
    private let ocrModel = OCRModel()
    
    var viewInfo: [RecognitionInfo] = []
    weak var delegate: ResultViewPresenterDelegate?
    
    func viewDidLoad() {
        ocrModel.register(id: "ResultViewPresenter", delegate: self)
    }
    
    func viewDidDisappear() {
        ocrModel.unregister(id: "ResultViewPresenter")
    }
    
    func tapSaveButton(titleText: String?, resultText: String) {
        guard let titleText = titleText else { return }
        if titleText == "" {
            delegate?.showAlert()
        } else {
            ocrModel.insert(titleText: titleText, resultText: resultText)
            delegate?.closeResultView()
        }
    }
    
}

extension ResultViewControllerPresenter: OCRModelDelegate {
    
    func reload(info: [RecognitionInfo]) {
        self.viewInfo = info.sorted {
            guard let lhsDate = $0.date,
                let rhsDate = $1.date else { return false }
            return lhsDate < rhsDate
        }
    }
}
