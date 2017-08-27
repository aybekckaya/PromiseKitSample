//
//  MenuVC.swift
//  PromiseKitSample
//
//  Created by aybek can kaya on 20/08/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import UIKit

class MenuVC: BaseVC {
    
    enum MenuViewItem:Int {
        case networkSample
        case locationSample
        
        func desc()->String {
            switch self {
            case .networkSample:
                return "Network Sample"
            case .locationSample:
                return "Location Sample"
            }
        }
        
        static func all()->[MenuViewItem] {
            return [MenuViewItem.networkSample , MenuViewItem.locationSample]
        }
    }

    @IBOutlet weak var tableViewMenu: UITableView!

    fileprivate var menuItems:[MenuViewItem] = MenuViewItem.all()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let vc:NetworkResultVC = NetworkResultVC(nibName: NetworkResultVC.identifier, bundle: nil)
        navigationController?.pushViewController(vc, animated: false)
        return
        
        
        title = "Promise Kit Sample"
        
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


extension MenuVC:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MenuCell = tableView.deque(at: indexPath)
        let descItem = menuItems[indexPath.row].desc()
        cell.lblMenuItem.text = descItem
        cell.updateUI()
        
        return cell
    }
}

extension MenuVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case MenuViewItem.locationSample.rawValue:
            break
        case MenuViewItem.networkSample.rawValue :
            let vc:NetworkVC = NetworkVC(nibName: NetworkVC.identifier, bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
            break
        default: break
        }
    }
}

