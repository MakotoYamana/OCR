//
//  APIClient.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/03.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import Foundation

enum Result {
    case success(Data)
    case failure(Error)
    case other
}

class APIClient {
    
    static func request(urlRequest: URLRequest, completionHandler: @escaping (Result) -> ()) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            switch (data, response, error) {
            case (_, _, let error?):
                completionHandler(.failure(error))
            case (let data?, _, _):
                completionHandler(.success(data))
            default:
                completionHandler(.other)
            }
            session.finishTasksAndInvalidate()
        }
        task.resume()
    }
    
}
