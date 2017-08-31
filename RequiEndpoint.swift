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
import Alamofire

enum RequiEndpoint:Endpoint {
    case GetRequest
    case GetRequestWithParameters(parameters:[String:Any])
    case PostRequest(parameters:[String:Any])
    case PostRequestWithMedia(parameters:[String:Any])
    case PostWithLocation(parameters:[String:Any])
    
    
    fileprivate var route: RouteParams {
        switch self {
        case .GetRequest:
            return (path: "sampleGetReq" , parameters:nil , responseType: RequiModel.self , method:HTTPMethod.get)
        case .GetRequestWithParameters(let parametersDct):
            return (path: "sampleGetReqParameters" , parameters:parametersDct , responseType: RequiModel.self , method:HTTPMethod.get)
        case .PostRequest(let parametersDct):
            return (path: "samplePostReq" , parameters:parametersDct , responseType: RequiModel.self , method:HTTPMethod.post)
        case .PostRequestWithMedia(let parametersDct):
             return (path: "samplePostReq" , parameters:parametersDct , responseType: RequiModel.self , method:HTTPMethod.post)
        case .PostWithLocation(let parametersDct):
            return (path: "post" , parameters:parametersDct , responseType: RequiModel.self , method:HTTPMethod.post)
        }
    }
}



extension RequiEndpoint {
  
    fileprivate static let urlStringBase:String = "https://httpbin.org/"
    
    func promise<T:JsonConvertible>()->Promise<T> {
        return route.method == .post ? postPromise() : getPromise()
    }
    
    private func getPromise<T:JsonConvertible>()->Promise<T> {
        return Promise{fulfill , reject in
            let fullPath:String = RequiEndpoint.urlStringBase+route.path
            
            Alamofire.request(fullPath, method: .get, parameters: route.parameters).responseJSON(completionHandler: {response in
                if loggingEnabled { debugPrint(response) }
                guard response.error == nil else {
                    reject(response.error!)
                    return
                }
                
                guard let jsonValue = response.result.value else {
                    let error = NSError(domain: "PromiseKitSampler", code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "JSON parsing error"])
                    reject(error)
                    return
                }
                
                let json = JSON(jsonValue)
                guard let model = self.route.responseType.init(json: json) as? T else {
                    let error = NSError(domain: "PromiseKitSampler", code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Cannot convert to model object"])
                    reject(error)
                    return
                }
                fulfill(model)
            })
        }
    }
    
    private func postPromise<T:JsonConvertible>()->Promise<T> {
        return Promise{fulfill , reject in
             let fullPath:String = RequiEndpoint.urlStringBase+route.path
            guard let parameters = route.parameters else {
                fatalError("Route should have parameters")
            }
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                for (key,value) in parameters {
                    if value is MediaNetwork {
                        let mediaStruct:MediaNetwork = value as! MediaNetwork
                        let imageData = mediaStruct.mediaData
                        let mime = mediaStruct.mimeType.rawValue
                        let filename = mediaStruct.mediaName
                        multipartFormData.append(imageData!, withName: key, fileName: filename, mimeType: mime)
                    }
                    else {
                        let str = String(describing:value)
                        let data = str.data(using: String.Encoding.utf8)
                        multipartFormData.append(data!, withName: key)
                    }
                }
                
            }, to:fullPath)
            { result in
                switch result {
                case .success(let upload , _ ,_):
                    
                    upload.uploadProgress(closure: { pr in
                        print("progress : \(pr)")
                    })
                    
                    upload.responseJSON(completionHandler: { response in
                        if loggingEnabled { debugPrint(response) }
                        guard response.error == nil else {
                            reject(response.error!)
                            return
                        }
                        
                        guard let jsonValue = response.result.value else {
                            let error = NSError(domain: "PromiseKitSampler", code: 0,
                                                userInfo: [NSLocalizedDescriptionKey: "JSON parsing error"])
                            reject(error)
                            return
                        }
                        
                        let json = JSON(jsonValue)
                        guard let model = self.route.responseType.init(json: json) as? T else {
                            let error = NSError(domain: "PromiseKitSampler", code: 0,
                                                userInfo: [NSLocalizedDescriptionKey: "Cannot convert to model object"])
                            reject(error)
                            return
                        }
                        fulfill(model)
                    })
                    
                    break
                case .failure(let error):
                    reject(error)
                    break
                }
            }
            
        }
        
    }
    
    fileprivate typealias RouteParams = (path: String, parameters: [String: Any]?, responseType: JsonConvertible.Type , method:HTTPMethod)
    
}









