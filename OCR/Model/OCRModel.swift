//
//  OCRModel.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/22.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

protocol OCRModelDelegate {
    func reload(info: [RecognitionInfo])
}

class OCRModel {
    
    private let coreDataManager = CoreDataManager.shared
    private let cloudVisionAPI = CloudVisionAPI()
    
    var delegates: [String: OCRModelDelegate] = [:]
    private var recognitionsInfo: [RecognitionInfo] = [] {
        didSet {
            delegates.values.forEach { delegate in
                delegate.reload(info: recognitionsInfo)
            }
        }
    }
    
    func register(id: String, delegate: OCRModelDelegate) {
        coreDataManager.delegate = self
        delegates[id] = delegate
    }
    
    func unregister(id: String) {
        delegates.removeValue(forKey: id)
    }
    
    func get() {
        coreDataManager.getInfo()
    }
    
    func insert(titleText: String, resultText: String) {
        let new = RecognitionInfo.new(titleText: titleText, detail: resultText)
        self.recognitionsInfo += [new]
        coreDataManager.insertData(with: new)
    }
    
    func update(titleText: String, detailText: String, info: RecognitionInfo) {
        var updated = info
        updated.title = titleText
        updated.detail = detailText
        updated.date = Date()
        coreDataManager.updateData(with: updated)
        
        self.recognitionsInfo = self.recognitionsInfo.map {
            guard $0.uniqueDate == info.uniqueDate else {
                return $0
            }
            return updated
        }
    }
    
    func delete(info: RecognitionInfo) {
        coreDataManager.deleteData(with: info)
        recognitionsInfo = recognitionsInfo.filter { $0.uniqueDate != info.uniqueDate }
    }
    
    func request(imageData: Data, completionHandler: @escaping (String) -> ()) {
        cloudVisionAPI.requestAPI(imageDataString: imageData.base64EncodedString()) { result in
            completionHandler(result)
        }
    }
    
}

extension OCRModel: CoreDataManagerDelegate {
    
    func recognitionResult(result: recognitionResultStatus) {
        switch result {
        case .success(let response):
            self.recognitionsInfo = response
        case .failuer(let error):
            self.delegates.values.forEach { delegate in
                // TODO: 各Presenterを経由してアラートを出す
            }
        case .empty:
            self.recognitionsInfo = []
        }
    }

}

struct RecognitionInfo {
    
    var title: String?
    var detail: String?
    var date: Date?
    var uniqueDate: Date
    
    static func new(titleText: String, detail: String) -> RecognitionInfo {
        return RecognitionInfo(title: titleText, detail: detail, date: Date(), uniqueDate: Date())
    }
    
}
