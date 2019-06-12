//
//  TopViewControllerPresenter.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/25.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

protocol TopViewPresenterDelegate: class {
    func reload()
}

class TopViewControllerPresenter {
    
    private let viewControllerModel = ViewControllerModel()

    var viewInfo: [RecognitionInfo] = []
    weak var delegate: TopViewPresenterDelegate?
    
    func viewDidLoad() {
        viewControllerModel.register(id: "TopViewPresenter", delegate: self)
    }
    
    func viewWillAppear() {
        getItems()
    }
    
    func viewDidDisappear() {
        viewControllerModel.unregister(id: "TopViewPresenter")
    }
    
    private func getItems() {
        viewInfo = viewControllerModel.get().sorted {
            guard let lhsDate = $0.date,
                let rhsDate = $1.date else { return false }
            return lhsDate < rhsDate
        }
        delegate?.reload()
    }
    
    func prepareFor(detailViewController: DetailViewController, info: RecognitionInfo) {
        detailViewController.detailViewControllerPresenter.setModel(model: viewControllerModel)
        detailViewController.info = info
    }
    
    func swipeDelete(info: RecognitionInfo) {
        viewControllerModel.delete(info: info)
    }
    
}

extension TopViewControllerPresenter: ViewControllerModelDelegate {
    
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
}
