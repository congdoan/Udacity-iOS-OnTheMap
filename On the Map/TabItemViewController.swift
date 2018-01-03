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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showPostLocationVC))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTabBarVisibility(true)
    }
    
    @objc func dismissTarBarController() {
        tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func showPostLocationVC() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PostLocationViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
