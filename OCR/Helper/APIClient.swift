//
//  APIClient.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/03.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

class APIClient {
    
    static func request(imageDataString: String, completionHandler: @escaping (Result<Data, Error>) -> ()) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let urlRequest = UrlRequester.create(jsonRequest: UrlRequester.createJsonRequest(imageDataString: imageDataString))
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let _ = response as? HTTPURLResponse {
                guard let data = data else {
                    fatalError("データ取得に失敗")
                }
                completionHandler(.success(data))
            } else if let error = error {
                completionHandler(.failure(error))
            } else {
                fatalError("その他のエラー")
            }
            session.finishTasksAndInvalidate()
        }
        task.resume()
    }
    
}
