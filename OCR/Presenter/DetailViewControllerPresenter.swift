//
//  DetailViewControllerPresenter.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/26.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

protocol DetailViewPresenterDelegate: class {
    func closeDetailView()
    func showAlert()
}

class DetailViewControllerPresenter {
    
    var viewControllerModel: ViewControllerModel?
    weak var delegate: DetailViewPresenterDelegate?
    
    var info: RecognitionInfo?
    
    func viewDidLoad() {
        viewControllerModel?.register(id: "DetailViewPresenter", delegate: self)
    }
    
    func viewDidDisappear() {
        viewControllerModel?.unregister(id: "DetailViewPresenter")
    }
    
    func setModel(model: ViewControllerModel) {
        viewControllerModel = model
    }
    
    func tapSaveButton(titleText: String?, detailText: String, info: RecognitionInfo?) {
        guard let titleText = titleText,
            let info = info else { return }
        if titleText == "" {
            delegate?.showAlert()
        } else {
            self.viewControllerModel?.update(titleText: titleText, detailText: detailText, info: info)
            delegate?.closeDetailView()
        }
    }
    
}

extension DetailViewControllerPresenter: ViewControllerModelDelegate {
    
    func reload(info: [RecognitionInfo]) {
        if let refreshedInfo = info.first(where: { $0.uniqueDate == self.info?.uniqueDate }) {
            self.info = refreshedInfo
        }
    }
}
