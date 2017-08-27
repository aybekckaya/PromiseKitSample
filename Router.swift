//
//  Router.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 27/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import SwiftyJSON


public enum CastingError: Error {
    case Failure(key: String)
}


// Helper function for Dictionary to get query string items
extension Dictionary {
    func toQueryItems(prefix: String = "") -> [NSURLQueryItem] {
        return self.flatMap { (key, value) -> [NSURLQueryItem] in
            var array: [NSURLQueryItem] = []
            guard let key = key as? String else {
                return array
            }
            let name = prefix + key
            
            switch value {
            case is String, is Int, is Double, is Float:
                array.append(NSURLQueryItem(name: name, value: String(describing: value)))
            case is Bool:
                array.append(NSURLQueryItem(name: name, value: (value as! Bool) ? "1" : "0"))
            case is Dictionary:
                array = (value as! Dictionary).toQueryItems(prefix: name)
            default:
                break
            }
            return array
        }
    }
}

enum HTTPMethod:String {
    case GET = "GET"
    case POST = "POST"
}

protocol JsonConvertible {
    init(json:JSON)
}

protocol Endpoint {
    var showWarning: Bool { get }
    var urlRequest: URLRequest { get }
    //func promise<T: JsonConvertible>() -> Promise<T>
}

extension Endpoint {
    func urlDataPromise() -> URLDataPromise {
        let _urlRequest = urlRequest
        let promise = URLDataPromise.go(_urlRequest) { completionHandler in
            let task = URLSession.shared.dataTask(with: _urlRequest, completionHandler: completionHandler)
            task.resume()
        }
        
        promise.catch { error in
            guard self.showWarning else { return }
            switch error {
            case PromiseKit.PMKURLError.invalidImageData(let request, let data):
                print("*** URLError: InvalidImageData *** \n \(request) \n \(String(data: data, encoding: String.Encoding(rawValue: 1))) \n")
                self.checkErrorData(data: data)
            case PromiseKit.PMKURLError.badResponse( let request, let data?, _):
                guard let dataString = String(data: data, encoding: String.Encoding(rawValue: 1)) else {return}
                print("*** URLError: BadResponse *** \n \(request) \n \(dataString) \n")
                #if DEBUG
                    // Show Alert
                    //WarningAlerts.showAlert(message: request.mainDocumentURL?.absoluteURL.absoluteString ?? "")
                #else
                #endif
                self.checkErrorData(data: data)
            case PromiseKit.PMKURLError.stringEncoding(let request, let data, _):
                print("*** URLError: StringEncoding *** \n \(request)  \n  \(String(data: data, encoding: String.Encoding(rawValue: 1))) \n")
                self.checkErrorData(data: data)
            default:
                print(type(of: error))
                let errorCode = error as NSError
                self.processError(errorCode)
            }
        }
        return promise
    }
    
    private func processError(_ error: NSError) {
        guard let currentController = UIApplication.topViewController() else { return }
        if (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorNetworkConnectionLost) {
            // Not internet connection
        } else {
          
            #if DEBUG
                if let errorURL = error.userInfo["NSErrorFailingURLStringKey"] as? String{
                    //WarningAlerts.showAlert(message: error.localizedDescription)
                   // WarningAlerts.showAlert(message: errorURL)
                }else{
                   // WarningAlerts.showAlert(message: error.localizedDescription)
                }
            #else
                //WarningAlerts.showAlert(message: localize("requestFailed"))
            #endif
            
        }
    }
    
    func checkErrorData(data: Data) {
        do {
            let json = JSON(data: data)
            print("json : \(json)")
            /*
            // Try to parse response data for friendly notification
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let dict = json as? [String: AnyObject], let jsonDict = dict["d"] as? JSON.JSON else { throw JSONError.unexpectedRootNode(json) }
            let response = try BaseResponse(json: jsonDict)
            //WarningAlerts.showAlert(message: response.Notification)
 */
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
            processError(error)
        }
    }
}


/*
 
 func createRequestBodyWith(parameters:[String:NSObject], filePathKey:String, boundary:String) -> NSData{
 
 let body = NSMutableData()
 
 for (key, value) in parameters {
 body.appendString(string: "--\(boundary)\r\n")
 body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
 body.appendString(string: "\(value)\r\n")
 }
 
 body.appendString(string: "--\(boundary)\r\n")
 
 var mimetype = "image/jpg"
 
 let defFileName = "yourImageName.jpg"
 
 let imageData = UIImageJPEGRepresentation(yourImage, 1)
 
 body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(defFileName)\"\r\n")
 body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
 body.append(imageData!)
 body.appendString(string: "\r\n")
 
 body.appendString(string: "--\(boundary)--\r\n")
 
 return body
 }
 
 
 
 func generateBoundaryString() -> String {
 return "Boundary-\(NSUUID().uuidString)"
 }
 
 
 
 extension NSMutableData {
 
 func appendString(string: String) {
 let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
 append(data!)
 }
 
 
 */


extension Endpoint {
    
    func getHttpBodyForPostRequest(parameters:[String:Any], filePathKey:String)->Data {
        let body:NSMutableData = NSMutableData()
        let boundary:String = "Boundary-\(NSUUID().uuidString)"
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
    }
    
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
 
}

enum RouterError: Error {
    case DataTypeMismatch
    case BusinessLogicError(Int, String)
}

