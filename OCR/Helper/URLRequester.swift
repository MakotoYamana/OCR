//
//  URLRequester.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/03.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import SwiftyJSON
import Keys

class URLRequester {
    
    static let cloudVisionAPIKey = OCRKeys().cloudVisionAPIKey
    static let googleURLString = "https://vision.googleapis.com/v1/images:annotate?key=\(cloudVisionAPIKey)"
    
    static func create(jsonRequest: [String: [String: Any]]) -> URLRequest {
        guard let url = URL(string: self.googleURLString) else { fatalError("URLが無効") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        guard let data = try? JSON(jsonRequest).rawData() else { fatalError("データへの変換に失敗") }
        urlRequest.httpBody = data
        
        return urlRequest
    }
    
    static func createJsonRequest(imageDataString: String) -> [String: [String: Any]] {
        return [
            "requests": [
                "image": [
                    "content": imageDataString
                ],
                "features": [
                    [
                        "type": "TEXT_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
    }
    
}
