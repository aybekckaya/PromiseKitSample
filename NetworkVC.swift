//
//  NetworkVC.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 27/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import UIKit

enum NetworkQueryPageType:Int {
    case requiSamplePOSTImage
    case locationAndRequestSample
    case photoLibrarySampleBasic
    case photoLibraryAndLocationSample
    
    /*will be implemented */
    case advancedChaining
    
    func stringify()->String {
        switch self {
        case .locationAndRequestSample:
            return "Location and request sample"
        case .photoLibrarySampleBasic:
            return "Photo Library sample"
        case .photoLibraryAndLocationSample:
            return "Photo Library and Location sample"
        
        default:
            return ""
        }
    }
    
    static func all()->[NetworkQueryPageType] {
        return [NetworkQueryPageType.locationAndRequestSample]
    }
}


class NetworkVC: BaseVC {

    
    @IBOutlet weak var tableViewMenu: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Network Menu"
        
        let cellNib = UINib(nibName: MenuCell.identifier, bundle: nil)
        tableViewMenu.register(cellNib, forCellReuseIdentifier: MenuCell.identifier)
        
        tableViewMenu.estimatedRowHeight = 50
        tableViewMenu.tableFooterView = UIView()
        tableViewMenu.delegate = self
        tableViewMenu.dataSource = self
        tableViewMenu.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension NetworkVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let items = NetworkQueryPageType.all()
        let cell:MenuCell = tableView.deque(at: indexPath)
        let descItem = items[indexPath.row].stringify()
        cell.lblMenuItem.text = descItem
        cell.updateUI()
        
        return cell
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkQueryPageType.all().count
    }
}



extension NetworkVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}







