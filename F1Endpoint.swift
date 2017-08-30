//
//  F1Endpoint.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 27/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON
import Alamofire

enum F1Endpoint:Endpoint {
    case GetSeasons
    case RaceScheduleEnum(year:String)
    
    fileprivate var route: RouteParams {
        switch self {
        case .GetSeasons:
            return (path: "seasons.json" , parameters:nil , responseType: Season.self , method:HTTPMethod.get)
        case .RaceScheduleEnum(let year):
            let path = year+".json"
            return (path: path , parameters:nil , responseType: RaceSchedule.self , method:HTTPMethod.get)
        }
        
    }
    
    
    var showWarning: Bool {
        get {
            return true
        }
    }
}



extension F1Endpoint {
    fileprivate static let baseUrl: URL = URL(string: baseApiURL)!
    
    func promise<T:JsonConvertible>()->Promise<T> {
        return Promise { fulfill, reject in
         
            let session = URLSession.shared
            let dataTask = session.dataTask(with: urlRequest) { data, response, error in
                
                guard error == nil else {
                    reject(error!)
                    return
                }
                
                guard let _data = data else {
                    let error = NSError(domain: "PromiseKitSampler", code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Data cannot get"])
                    reject(error)
                    return
                }
                
                let json = JSON(data:_data)
                guard let model = self.route.responseType.init(json: json) as? T else {
                    let error = NSError(domain: "PromiseKitSampler", code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Cannot convert to model object"])
                    reject(error)
                    return
                }
                fulfill(model)
            }    
            dataTask.resume()
        }
    }
    
    
    fileprivate typealias RouteParams = (path: String, parameters: [String: Any]?, responseType: JsonConvertible.Type , method:HTTPMethod)
    
    var urlRequest: URLRequest {
        let _route = route
        return urlRequest(path: route.path, parameters: _route.parameters , method:route.method)
    }
    
    fileprivate func urlRequest(path: String, parameters: [String: Any]? , method:HTTPMethod) -> URLRequest {
        
        let url = F1Endpoint.baseUrl.appendingPathComponent(path)
        let request = NSMutableURLRequest(url: url)
        //request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
       // let parameters = parameters ?? [:]
       // request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
       
        return request as URLRequest
        
    }
    
}
