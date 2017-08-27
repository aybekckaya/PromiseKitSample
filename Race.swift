//
//  Race.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 27/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import UIKit
import SwiftyJSON

class Race: NSObject {

    /*
     "season": "2012",
     "round": "1",
     "url": "http:\/\/en.wikipedia.org\/wiki\/2012_Australian_Grand_Prix",
     "raceName": "Australian Grand Prix",
     "Circuit": {
					"circuitId": "albert_park",
					"url": "http:\/\/en.wikipedia.org\/wiki\/Melbourne_Grand_Prix_Circuit",
					"circuitName": "Albert Park Grand Prix Circuit",
					"Location": {
     "lat": "-37.8497",
     "long": "144.968",
     "locality": "Melbourne",
     "country": "Australia"
					}
     },
     "date": "2012-03-18",
     "time": "06:00:00Z"
     }
     */
    
    let season:String?
    let raceName:String?
    
    init(json: JSON) {
      
       season = json["season"].string ?? ""
       raceName = json["raceName"].string ?? ""
        
       super.init()
    }
}
