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
    
    var viewInfo: [RecognitionInfo] = []
    weak var delegate: ResultViewPresenterDelegate?
    
    func viewDidLoad() {
        viewControllerModel.register(id: "ResultViewPresenter", delegate: self)
    }
    
    func viewDidDisappear() {
        viewControllerModel.unregister(id: "ResultViewPresenter")
    }
    
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

extension ResultViewControllerPresenter: ViewControllerModelDelegate {
    
    func reload(info: [RecognitionInfo]) {
        self.viewInfo = info.sorted {
            guard let lhsDate = $0.date,
                let rhsDate = $1.date else { return false }
            return lhsDate < rhsDate
        }
    }
}
