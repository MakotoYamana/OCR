//
//  ViewControllerModel.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/22.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

class ViewControllerModel {
    
    private let coreDataManager = CoreDataManager()
    private let cloudVisionAPI = CloudVisionAPI()
    
    func get() -> [Item] {
        return coreDataManager.getData()
    }
    
    func insert(titleText: String, resultText: String) {
        coreDataManager.insertData(titleText: titleText, resultText: resultText)
    }
    
    func update(titleText: String, detailText: String, item: Item) {
        coreDataManager.updateData(titleText: titleText, detailText: detailText, item: item)
    }
    
    func delete(item: Item) {
        coreDataManager.deleteData(item: item)
    }
    
    func request(imageData: Data, completionHandler: @escaping (String) -> ()) {
        cloudVisionAPI.requestAPI(imageDataString: imageData.base64EncodedString()) { result in
            completionHandler(result)
        }
    }
    
}
