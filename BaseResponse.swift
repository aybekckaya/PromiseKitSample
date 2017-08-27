//
//  BaseResponse.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 27/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import Foundation

class BaseResponse: JsonInitializable, JsonConvertible {
    
    let url:String?
    let notificationDesc:String?
    /*
    let ErrorCode: Int?
    let _FriendlyNotification: String?
    private let _Notification: String?
    private let _Success: Bool?
    private let _IsSuccess: Bool?
    private let _ResultMessage: String?
    let ShowNotification: Bool?
 */
    
    init() {
        /*
        self.ErrorCode = nil
        _FriendlyNotification = nil
        _Notification = nil
        _Success = nil
        _IsSuccess = nil
        _ResultMessage = nil
        ShowNotification = nil
 */
        url = nil
        notificationDesc = nil
    }
    
    required init(json: JSON.JSON) throws {
        /*
        ErrorCode = try json.getOptional(key: "ErrorCode")
        _FriendlyNotification = try json.getOptional(key: "FriendlyNotification")
        _Notification = try json.getOptional(key: "Notification")
        _Success = try json.getOptional(key: "Success")
        _IsSuccess = try json.getOptional(key: "IsSuccess")
        _ResultMessage = try json.getOptional(key: "ResultMessage")
        ShowNotification = try json.getOptional(key: "ShowNotification")
 */
        url = try json.getOptional(key: "url")
        notificationDesc = try json.getOptional(key: "notification")
    }
    
    var Notification: String {
        return notificationDesc ?? ""
    }
    
    var Success: Bool {
        return true
        /*
        if let Success = _Success {
            return Success
        }
        if let IsSuccess = _IsSuccess {
            return IsSuccess
        }
        return false
 */
    }
    
    func toJSON() -> JSON.JSON {
        var json: JSON.JSON =  [:]
        json["url"] = url
        json["notification"] = notificationDesc
        /*
        json["ErrorCode"] = ErrorCode
        if let _FriendlyNotification = _FriendlyNotification {
            json["_FriendlyNotification"] = _FriendlyNotification
        }
        if let _Notification = _Notification {
            json["_Notification"] = _Notification
        }
        if let _Success = _Success {
            json["_Success"] = _Success
        }
        if let _IsSuccess = _IsSuccess {
            json["_IsSuccess"] = _IsSuccess
        }
        if let _ResultMessage = _ResultMessage {
            json["_ResultMessage"] = _ResultMessage
        }
        if let ShowNotification = ShowNotification {
            json["ShowNotification"] = ShowNotification
        }
 */
        return json
    }
}

