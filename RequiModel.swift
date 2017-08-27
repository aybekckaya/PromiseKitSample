//
//  RequiModel.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 27/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import UIKit
import SwiftyJSON

class RequiModel: BaseResponse {

    required init(json: JSON) {
        let theJSON:JSON = json["MRData"]
        
        super.init(json: theJSON)
    }
    
}
