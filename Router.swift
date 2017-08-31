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


enum MimeNetwork:String {
    case JPG = "image/jpeg"
    case PNG = "image/png"
    case MP3 = "audio/mpeg3"
}

struct MediaNetwork {
    var mimeType:MimeNetwork = MimeNetwork.JPG
    var mediaName:String = ""
    var mediaData:Data?
}


protocol JsonConvertible {
    init(json:JSON)
}

protocol Endpoint {
}

extension Endpoint {
    
}


enum RouterError: Error {
    case DataTypeMismatch
    case BusinessLogicError(Int, String)
}

