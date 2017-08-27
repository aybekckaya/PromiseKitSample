//
//  RequiEndpoint.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 27/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

enum RequiEndpoint:Endpoint {
    case GetRequest
    case GetRequestWithParameters(parameters:[String:Any])
    case PostRequest(parameters:[String:Any])
    
    
    fileprivate var route: RouteParams {
        switch self {
        case .GetRequest:
            return (path: "sampleGetReq" , parameters:nil , responseType: Season.self , method:HTTPMethod.GET)
        case .GetRequestWithParameters(let parametersDct):
            return (path: "sampleGetReqParameters" , parameters:parametersDct , responseType: Season.self , method:HTTPMethod.GET)
        case .PostRequest(let parametersDct):
            return (path: "samplePostReq" , parameters:parametersDct , responseType: Season.self , method:HTTPMethod.POST)
        }
        
        
    }
    
    
    var showWarning: Bool {
        get {
            return true
        }
    }
}



extension RequiEndpoint {
    fileprivate static let baseUrl: URL = URL(string: "http://localhost:8888/mstGame/public/samples/")!
    
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
        
        
        
        
        let url = RequiEndpoint.baseUrl.appendingPathComponent(path)
        let request = NSMutableURLRequest(url: url)
        //request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        // let parameters = parameters ?? [:]
        // request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        return request as URLRequest
        
    }
    
    

    
    
    
    
    
}









