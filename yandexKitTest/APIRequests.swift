//
//  APIRequests.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 25/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import Foundation
import Alamofire

class APIRequests {
        
    //GET Request
    func performGETRequest(url: String, completion:@escaping(_ response: DataResponse<Any>) -> Void) {
        if let encodedURL = NSURL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            Alamofire.request(encodedURL.absoluteString!).responseJSON { (dataResponse) in
                completion(dataResponse)
            }
        }
    }
    
}
