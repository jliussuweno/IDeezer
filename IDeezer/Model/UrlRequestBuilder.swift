//
//  UrlRequestBuilder.swift
//  day six
//
//  Created by BCA_GSIT_Macbook_2 on 8/19/19.
//  Copyright © 2019 BCA_GSIT_Macbook_2. All rights reserved.
//

import UIKit

public class UrlRequestBuilder: NSObject {
    
    func buildUrlRequestDeezer(artist: String?) -> URLRequest {
        var urlString : String = "https://deezerdevs-deezer.p.rapidapi.com/search"
        if artist != nil {
            urlString = urlString + "?q=" + artist!
        }
        
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL.init(string: urlString)
        var urlRequest : URLRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("deezerdevs-deezer.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        urlRequest.addValue("1aaf44486dmshce55c5a82a7edc9p188e0ajsn181bded96bb9", forHTTPHeaderField: "x-rapidapi-key")
        urlRequest.timeoutInterval = 30
        return urlRequest
    }
    
    
}
