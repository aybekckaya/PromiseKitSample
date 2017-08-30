//
//  NetworkResultVC.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 27/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import UIKit
import PromiseKit

class NetworkResultVC: BaseVC {

    var queryType:NetworkQueryPageType = NetworkQueryPageType.requiSamplePOST
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeRequest()
    }

    
    private func makeRequest() {
        switch queryType {
        case .allSeasons:
            seasonsRequest()
        case .cocktailCategoryList:
            
            break
        case .raceSchedule:
            raceScheduleRequest()
        case .requiSamplePOST:
            requiSamplePostRequest()
        case .requiSampleGET:
            requiSampleGetRequest()
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
    func seasonsRequest() {
        let seasonPromise:Promise<Season> = F1Endpoint.GetSeasons.promise()
        seasonPromise.then { seasonsData -> Void in
            print("season data : \(seasonsData)")
        }.catch { error in
            print("error : \(error)")
        }
    }
    
    
    func raceScheduleRequest() {
        let racePromise:Promise<RaceSchedule> = F1Endpoint.RaceScheduleEnum(year: "2001").promise()
        racePromise.then { scheduleData -> Void in
            print("data : \(scheduleData)")
        }.catch { error in
            print("error :\(error)")
        }
    }
    
    
    func requiSampleGetRequest() {
        let getPromise:Promise<RequiModel> = RequiEndpoint.GetRequest.promise()
        getPromise.then { model -> Void in
            print("model : \(model)")
            }.catch {error in
                print("erorr :\(error)")
        }
    }
    
    
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
    
    
    
}

/*
 let areasPromise: Promise<AreasResponse> = CatalogEndpoint.GetAreas(catalogName: catalogName).promise().wrapWithLoadingAnimator(view: self.view)
 areasPromise.then {areasResponse  -> Void in
 self.regionsDidLoad(regions: areasResponse.ResultSet)
 self.reloadTableView()
 self.tableView.isHidden = false
 }.catch { (error) in
 print(error)
 }
 
 
 
 
 private func getUserInfo()->Promise<Void> {
 return Promise {fulfill , reject in
 guard 🔒.loggedIn else {
 fulfill()
 return
 }
 firstly(execute: { () -> Promise<GetCurrentUserInfoResponse> in
 return UserEndpoint.GetCurrentUserInfo.promise()
 }).then(execute: { response -> Void in
 💾.saveCurrentUserInfoResponse(userInfoResponse: response)
 fulfill()
 }).catch(execute: { error in
 reject(error)
 })
 }
 }

 
 
 */
/*
// Promises
extension NetworkResultVC {
    func seasonRequestPromise()->Promise<Season> {
        return Promise {fulfill , reject in
                firstly(execute: { () -> Promise<Season> in
                    return F1Endpoint.GetSeasons.promise()
                })
        }
    }
}

*/



