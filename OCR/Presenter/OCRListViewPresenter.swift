//
//  OCRListViewPresenter.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/25.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

protocol OCRListViewPresenterModel {
    func register(id: String, delegate: OCRModelDelegate)
    func get()
    func delete(info: RecognitionInfo)
}

protocol OCRListViewPresenterDelegate: class {
    func reload()
    func showAlert(title: String, message: String)
}

class OCRListViewPresenter {
    
    private var model: OCRListViewPresenterModel?
    weak var delegate: OCRListViewPresenterDelegate?
    var viewInfo: [RecognitionInfo] = []
    
    init(model: OCRListViewPresenterModel) {
        self.model = model
    }
    
    func viewDidLoad() {
        model?.register(id: "OCRListViewPresenter", delegate: self)
        getItems()
    }
    
    private func getItems() {
        model?.get()
    }
    
    func prepareFor(recognitionDetailView: RecognitionDetailView, info: RecognitionInfo) {
        recognitionDetailView.info = info
    }
    
    func swipeDelete(info: RecognitionInfo) {
        model?.delete(info: info)
    }
    
}

extension OCRListViewPresenter: OCRModelDelegate {
    
    func reload(info: [RecognitionInfo]) {
        defer {
            delegate?.reload()
        }
        self.viewInfo = info.sorted {
            guard let lhsDate = $0.date,
                let rhsDate = $1.date else { return false }
            return lhsDate < rhsDate
        }
    }
    
    func showAlert(errorType: ErrorType) {
        switch errorType {
        case .fetch:
            self.delegate?.showAlert(title: "データ取得に失敗しました", message: "")
        case .update:
            break
        case .delete:
            self.delegate?.showAlert(title: "データ削除に失敗しました", message: "")
        }
    }
    
}
