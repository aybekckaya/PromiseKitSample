//
//  BaseResponse.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 27/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import Foundation
import SwiftyJSON

class BaseResponse: JsonConvertible {
    
    let url:String?
    let notificationDesc:String?
    var total:Int = 0
    
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
        total = 0
    }
    
    required init(json: JSON) {
        /*
        ErrorCode = try json.getOptional(key: "ErrorCode")
        _FriendlyNotification = try json.getOptional(key: "FriendlyNotification")
        _Notification = try json.getOptional(key: "Notification")
        _Success = try json.getOptional(key: "Success")
        _IsSuccess = try json.getOptional(key: "IsSuccess")
        _ResultMessage = try json.getOptional(key: "ResultMessage")
        ShowNotification = try json.getOptional(key: "ShowNotification")
 */
        url = json["url"].string
        notificationDesc = json["notification"].string
        total = json["total"].int ?? 0
        
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
    
}

