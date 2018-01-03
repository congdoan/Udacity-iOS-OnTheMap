//
//  PostLocationViewController.swift
//  On the Map
//
//  Created by Cong Doan on 1/3/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit

class PostLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Post Location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(popNavigationStack))
        
        setTabBarVisibility(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setTabBarVisibility(true)
    }
    
    private func setTabBarVisibility(_ visible: Bool) {
        tabBarController?.tabBar.isHidden = !visible
    }
    
    @objc func popNavigationStack() {
        navigationController?.popViewController(animated: true)
    }

}
