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
    fileprivate static let urlStringBase:String = "http://localhost:8888/mstGame/public/samples/"
    
    func promise<T:JsonConvertible>()->Promise<T> {
        
        return route.method == .post ? postPromise() : getPromise()
        /*
        return Promise {fulfill , reject in
            let fullPath:String = RequiEndpoint.urlStringBase+route.path
            
            Alamofire.request(fullPath, method: route.method, parameters: route.parameters).responseJSON(completionHandler: {response in
                    debugPrint(response)
            })
        }
 */
        
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
                        // multipartFormData.append(imageData!, withName: "photo_path", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
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
    
    
    
    
    /*
     
     func postRequestWithImage() {
     //https://httpbin.org/post
     // http://localhost:8888/mstGame/public/samples/samplePostReq
     let image = UIImage(named: "gamze.jpg")
     let imageData = UIImageJPEGRepresentation(image!, 0.7)
     
     let strData = "aybek Can".data(using: String.Encoding.utf8)
     
     Alamofire.upload(multipartFormData: { (multipartFormData) in
     multipartFormData.append(imageData!, withName: "photo_path", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
     multipartFormData.append(imageData!, withName: "photo_path2222", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
     multipartFormData.append(strData!, withName: "StrDataName")
     }, to:"http://localhost:8888/mstGame/public/samples/samplePostReq")
     { (result) in
     switch result {
     case .success(let upload, _, _):
     
     upload.uploadProgress(closure: { (Progress) in
     print("Upload Progress: \(Progress.fractionCompleted)")
     })
     
     upload.responseJSON { response in
     //self.delegate?.showSuccessAlert()
     print(response.request)  // original URL request
     print(response.response) // URL response
     print(response.data)     // server data
     print(response.result)   // result of response serialization
     //                        self.showSuccesAlert()
     //self.removeImage("frame", fileExtension: "txt")
     if let JSON = response.result.value {
     print("JSON: \(JSON)")
     }
     }
     
     case .failure(let encodingError):
     //self.delegate?.showFailAlert()
     print(encodingError)
     }
     
     }
     }
     
     
     
     */
    
    
    /*
    func promise<T:JsonConvertible>()->Promise<T> {
        return Promise { fulfill, reject in
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: urlRequest) { data, response, error in
                
                if loggingEnabled {
                   let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("json : \(json)")
                }
                
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
    */
    
    fileprivate typealias RouteParams = (path: String, parameters: [String: Any]?, responseType: JsonConvertible.Type , method:HTTPMethod)
    
    var urlRequest: URLRequest {
        let _route = route
        return urlRequest(path: route.path, parameters: _route.parameters , method:route.method)
    }
    
    fileprivate func urlRequest(path: String, parameters: [String: Any]? , method:HTTPMethod) -> URLRequest {
    
        let url = RequiEndpoint.baseUrl.appendingPathComponent(path)
        let request = NSMutableURLRequest(url: url)
       // request.setValue("multipart/form-data; boundary=\(NSUUID().uuidString)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        if method == HTTPMethod.post {
            let data:Data = getHttpBodyForPostRequest(parameters: parameters)
            request.httpBody = data
        }
        // let parameters = parameters ?? [:]
        // request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        return request as URLRequest
        
    }

    
}









