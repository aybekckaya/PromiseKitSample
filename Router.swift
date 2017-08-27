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


public enum CastingError: Error {
    case Failure(key: String)
}

// Helper functions for Dictionary to get values with certain type or throw
extension Dictionary {
    
    func get<T>(key: String) throws -> T {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], let objAs = obj as? T else {
            throw CastingError.Failure(key: key)
        }
        return objAs
    }
    
    func getOptional<T>(key: String) throws -> T? {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], !(obj is NSNull) else {
            return nil
        }
        guard let objAs = obj as? T else {
            throw CastingError.Failure(key: key)
        }
        return objAs
    }
    
    func get<T: JsonInitializable>(key: String) throws -> T {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], let objAs = obj as? [String: AnyObject] else {
            throw CastingError.Failure(key: key)
        }
        return try T(json: objAs)
    }
    
    func getOptional<T: JsonInitializable>(key: String) throws -> T? {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], !(obj is NSNull) else {
            return nil
        }
        guard let objAs = obj as? [String: AnyObject] else {
            throw CastingError.Failure(key: key)
        }
        return try T(json: objAs)
    }
    
    func get<T: JsonInitializable>(key: String) throws -> [T] {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], let objAs = obj as? [[String: AnyObject]] else {
            throw CastingError.Failure(key: key)
        }
        return try objAs.map { try T(json: $0)}
    }
    
    func getOptional<T: JsonInitializable>(key: String) throws -> [T]? {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], !(obj is NSNull) else {
            return nil
        }
        guard let objAs = obj as? [[String: AnyObject]] else {
            throw CastingError.Failure(key: key)
        }
        return try objAs.map { try T(json: $0)}
    }
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

protocol Endpoint {
    var showWarning: Bool { get }
    var urlRequest: URLRequest { get }
    func promise<T: JsonInitializable>() -> Promise<T>
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
            // Try to parse response data for friendly notification
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let dict = json as? [String: AnyObject], let jsonDict = dict["d"] as? JSON.JSON else { throw JSONError.unexpectedRootNode(json) }
            let response = try BaseResponse(json: jsonDict)
            //WarningAlerts.showAlert(message: response.Notification)
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
            processError(error)
        }
    }
}

public struct JSON {
    // This typealias is declared in a dummy    JSON struct because global declarations may increase build time
    typealias JSON = [String: Any]
}

protocol JsonInitializable {
    init(json: JSON.JSON) throws
}

extension JsonInitializable {
    init?(persistanceKey: String) {
        guard let jsonObj = UserDefaults.standard.object(forKey: persistanceKey) as? JSON.JSON else { return nil }
        try? self.init(json: jsonObj)
    }
}

extension JsonConvertible {
    func persist(key: String) {
        let json = self.toJSON()
        UserDefaults.standard.set(json, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func removeNilParameters(parameters: [String: Any?]) -> JSON.JSON {
        var requestJSON: JSON.JSON = [:]
        parameters.lazy.filter { $0.1 != nil }.forEach { requestJSON[$0.0] = $0.1 }
        return requestJSON
    }
}

protocol JsonConvertible {
    func toJSON() -> JSON.JSON
}

enum RouterError: Error {
    case DataTypeMismatch
    case BusinessLogicError(Int, String)
}

