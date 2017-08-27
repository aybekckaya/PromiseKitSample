//
//  Season.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 27/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import Foundation

final class Season: BaseResponse {
    
    
    
    required init(json: JSON.JSON) throws {
        let theJSON:JSON.JSON = try json.get(key: "MRData")
        
        try super.init(json: theJSON)
    }
}
