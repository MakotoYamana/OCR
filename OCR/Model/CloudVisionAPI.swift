//
//  CloudVisionAPI.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/03.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import SwiftyJSON

class CloudVisionAPI {
    
    func requestAPI(imageDataString: String, completionHandler: @escaping (String) -> ()) {
        let urlRequest = URLRequester.create(jsonRequest: URLRequester.createJsonRequest(imageDataString: imageDataString))
        
        APIClient.request(urlRequest: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let json = try JSON(data: data)
                    guard let text = json["responses"][0]["fullTextAnnotation"]["text"].rawString() else { return }
                    completionHandler(text)
                } catch let error {
                    completionHandler(error.localizedDescription)
                }
            case .failure(let error):
                completionHandler(error.localizedDescription)
            case .other:
                // FIXME: このケースでのエラーハンドリング
                completionHandler("other")
            }
        }
    }
    
}
