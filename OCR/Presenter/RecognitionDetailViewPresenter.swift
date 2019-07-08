//
//  RecognitionDetailViewPresenter.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/26.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

protocol RecognitionDetailViewPresenterDelegate: class {
    func closeDetailView()
    func showAlert(title: String, message: String)
}

class RecognitionDetailViewPresenter {
    
    private var model: RecognitionDetailViewPresenterModel?
    weak var delegate: RecognitionDetailViewPresenterDelegate?
    private var info: RecognitionInfo?
    
    init(model: RecognitionDetailViewPresenterModel = OCRModel.shared) {
        self.model = model
    }
    
    func viewDidLoad() {
        model?.register(id: "RecognitionDetailViewPresenter", delegate: self)
    }
    
    func viewDidDisappear() {
        model?.unregister(id: "RecognitionDetailViewPresenter")
    }
    
    func tapSaveButton(titleText: String?, detailText: String, info: RecognitionInfo?) {
        guard let titleText = titleText,
            let info = info else { return }
        if titleText == "" {
            delegate?.showAlert(title: "タイトルを入力してください", message: "")
        } else {
            model?.update(titleText: titleText, detailText: detailText, info: info)
            delegate?.closeDetailView()
        }
    }
    
}

extension RecognitionDetailViewPresenter: OCRModelDelegate {
    
    func reload(info: [RecognitionInfo]) {
        if let refreshedInfo = info.first(where: { $0.uniqueDate == self.info?.uniqueDate }) {
            self.info = refreshedInfo
        }
    }
    
    func showAlert(errorType: ErrorType) {
        switch errorType {
        case .fetch:
            break
        case .update:
            self.delegate?.showAlert(title: "データ更新に失敗しました", message: "")
        case .delete:
            break
        }
    }
    
}
