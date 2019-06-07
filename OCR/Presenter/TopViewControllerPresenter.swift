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

    var items: [Item] = []
    weak var delegate: TopViewPresenterDelegate?
    
    func viewDidLoad(delegate: TopViewPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func viewWillAppear() {
        getItems()
    }
    
    private func getItems() {
        items = viewControllerModel.get().sorted {
            guard let lhsDate = $0.date,
                let rhsDate = $1.date else { return false }
            return lhsDate < rhsDate
        }
        delegate?.reload()
    }
    
    func prepareFor(detailViewController: DetailViewController, item: Item) {
        detailViewController.detailViewControllerPresenter.setModel(model: viewControllerModel)
        detailViewController.item = item
    }
    
    func swipeDelete(item: Item) {
        viewControllerModel.delete(item: item)
        getItems()
    }
    
}
