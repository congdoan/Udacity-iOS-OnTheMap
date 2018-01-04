//
//  UserTabBarController.swift
//  On the Map
//
//  Created by Cong Doan on 1/2/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit

class UserTabBarController: UITabBarController {

    var userPins = [UserPin]() {
        didSet {
            for navigationController in viewControllers! {
                print(type(of: navigationController))
                for vc in navigationController.childViewControllers {
                    print(type(of: vc))
                }
                if let tabItemViewController = navigationController.childViewControllers.first as? TabItemViewController {
                    tabItemViewController.hideDataFetchingIndicator()
                    tabItemViewController.updateUI()
                }
            }
        }
    }
    
}
