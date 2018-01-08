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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showPostLocationVC))
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchData))
        navigationItem.rightBarButtonItems = [addItem, refreshItem]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTabBarVisibility(true)
    }
    
    @objc func logout() {
        UdacityClient.shared.logout() { (_, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.tabBarController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func showPostLocationVC() {
        if isNetworkDisconnected() {
            return
        }
        
        if AppData.shared.objectIdOfUserLocation != nil {
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
        
        ParseClient.shared.getUserPins { (userPins, error) in
            self.hideDataFetchingIndicator()
            
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            
            let navigationControllers = (self.tabBarController as! UserTabBarController).viewControllers!
            let tabItemViewControllers = navigationControllers.map {$0.childViewControllers.first as! TabItemViewController}
            AppData.shared.setUserPins(userPins as! [UserPin], observers: tabItemViewControllers)
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
