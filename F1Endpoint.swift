//
//  F1Endpoint.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 27/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import Foundation
import PromiseKit

enum F1Endpoint:Endpoint {
    case GetSeasons
    
    fileprivate var route: RouteParams {
        switch self {
        case .GetSeasons:
            return (path: "seasons.json" , parameters:nil , responseType: Season.self , method:HTTPMethod.GET)
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
    func promise<T: JsonInitializable>() -> Promise<T> {
        return urlDataPromise()
            .asDictionary()
            .then { data -> T in
                guard let d = (data["d"] ?? data) as? [String: Any], let obj = try self.route.responseType.init(json: d) as? T, let response = obj as? BaseResponse else { throw RouterError.DataTypeMismatch }
                guard response.Success else { throw RouterError.BusinessLogicError(response.ErrorCode ?? 0, response.Notification) }
                return obj
        }
    }
    
    fileprivate typealias RouteParams = (path: String, parameters: [String: Any]?, responseType: JsonInitializable.Type , method:HTTPMethod)
    
    var urlRequest: URLRequest {
        let _route = route
        return urlRequest(path: route.path, parameters: _route.parameters , method:route.method)
    }
    
    fileprivate func urlRequest(path: String, parameters: [String: Any]? , method:HTTPMethod) -> URLRequest {
        let url = F1Endpoint.baseUrl.appendingPathComponent(path)
        let request = NSMutableURLRequest(url: url)
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        let parameters = parameters ?? [:]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
       
        return request as URLRequest
    }
    
    fileprivate func removeNilParamters(parameters: [String: Any?]) -> JSON.JSON {
        var requestJSON: JSON.JSON = [:]
        parameters.lazy.filter { $0.value != nil }.forEach { requestJSON[$0.key] = $0.value }
        return requestJSON
    }
}
