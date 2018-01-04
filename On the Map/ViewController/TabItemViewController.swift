//
//  TabItemViewController.swift
//  On the Map
//
//  Created by Cong Doan on 1/3/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit

class TabItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "On the Map"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(dismissTarBarController))
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showPostLocationVC))
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchData))
        navigationItem.rightBarButtonItems = [addItem, refreshItem]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTabBarVisibility(true)
    }
    
    @objc func dismissTarBarController() {
        tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func showPostLocationVC() {
        if isNetworkDisconnected() {
            return
        }
        
        if ParseClient.sharedInstance().objectIdOfUserLocation != nil {
            let message = "You have already posted a Student Location. Would you like to Overwrite it"
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let actionOverwrite = UIAlertAction(title: "Overwrite", style: .default) { (_) in
                self.pushPostLocationVC()
            }
            alert.addAction(actionOverwrite)
            let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(actionCancel)
            present(alert, animated: true, completion: nil)
        } else {
            pushPostLocationVC()
        }
    }
    
    @objc func fetchData() {
        if isNetworkDisconnected() {
            return
        }
        
        showDataFetchingIndicator()
        
        ParseClient.sharedInstance().getUserPins { (userPins, error) in
            self.hideDataFetchingIndicator()
            
            if let userPins = userPins {
                (self.tabBarController as! UserTabBarController).userPins = userPins
            } else if let error = error {
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func showDataFetchingIndicator() {
    }
    
    func hideDataFetchingIndicator() {
    }
    
    func updateUI() {
    }
    
    private func pushPostLocationVC() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PostLocationViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
