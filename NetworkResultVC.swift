//
//  NetworkResultVC.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 27/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import UIKit
import PromiseKit
import CoreLocation

class NetworkResultVC: BaseVC {

    var queryType:NetworkQueryPageType = NetworkQueryPageType.photoLibrarySample
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeRequest()
    }

    
    private func makeRequest() {
        switch queryType {

        case .photoLibrarySample:
            photoLibraryRequest()

        case .locationAndRequestSample:
            locationAndRequi()
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


// Network request
extension NetworkResultVC {

    
    
    func requiSamplePostRequest() {
        
        let image = UIImage(named:"sampleImage.jpg")
        let data = UIImageJPEGRepresentation(image!, 1)
        let media = MediaNetwork(mimeType: MimeNetwork.JPG, mediaName: "sampleMediaImage", mediaData: data)
        
        let parameters:[String:Any] = ["name":"Aybek" , "age":33 , "sayHi":true , "sampleMedia":media]
        
        let postPromise:Promise<RequiModel> = RequiEndpoint.PostRequest(parameters: parameters).promise()
        postPromise.then { model -> Void in
            print("model :\(model)")
            }.catch {error in
                print("error: \(error)")
        }
    }
    
    func locationAndRequi() {
        let image = UIImage(named:"sampleImage.jpg")
        let data = UIImageJPEGRepresentation(image!, 1)
        let media = MediaNetwork(mimeType: MimeNetwork.JPG, mediaName: "sampleMediaImage", mediaData: data)
        let parameters:[String:Any] = ["name":"Aybek" , "age":33 , "sayHi":true , "sampleMedia":media]
        
         let postPromise:Promise<RequiModel> = RequiEndpoint.PostWithLocation(parameters: parameters).promise()
        
        CLLocationManager.requestAuthorization().then{ authStatus->Promise<CLLocation> in
            guard authStatus == CLAuthorizationStatus.authorizedWhenInUse else {
                    let error = NSError(domain: "PromiseKitSampler", code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "UnAuthorized location"])
                    throw error
                }
                return CLLocationManager.promise()
            }.then {location ->Promise<RequiModel>  in
                print("locaiton : \(location)")
                return postPromise
            }.then { reqModel -> Void in
                print("req Model :\(reqModel)")
            }.catch { error in
                print("err : \(error)")
             }
    }
    

    
    func photoLibraryRequest() {

        
    }
    
}







