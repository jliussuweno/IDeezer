//
//  RestWebService.swift
//  day six
//
//  Created by BCA_GSIT_Macbook_2 on 8/19/19.
//  Copyright © 2019 BCA_GSIT_Macbook_2. All rights reserved.
//

import UIKit

class RestWebService: NSObject {
    
    func sendRequest(urlRequest: URLRequest, input: Dictionary<String, String>?, completion: @escaping (Any?, Error?) -> Void ) {
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)
        print("Send Request To: " + urlRequest.url!.absoluteString)
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil {
                completion(nil, error)
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    print("Get Response : ")
                    print(json)
                    completion(json, nil)
                } else {
                    completion(nil, nil)
                }
            }
        })
        task.resume()
    }
    
}
