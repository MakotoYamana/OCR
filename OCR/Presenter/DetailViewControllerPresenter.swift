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
    
    func setModel(model: ViewControllerModel) {
        viewControllerModel = model
    }
    
    func tapSaveButton(titleText: String?, detailText: String, item: Item?) {
        guard let titleText = titleText,
            let item = item else { return }
        if titleText == "" {
            delegate?.showAlert()
        } else {
            self.viewControllerModel?.update(titleText: titleText, detailText: detailText, item: item)
            delegate?.closeDetailView()
        }
    }
    
}
