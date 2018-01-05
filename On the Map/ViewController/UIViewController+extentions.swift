//
//  UIViewController+extentions.swift
//  On the Map
//
//  Created by Cong Doan on 1/3/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func isNetworkDisconnected() -> Bool {
        if Reachability.isNotConnected() {
            showAlert(message: "The Internet connection appears to be offline.")
            return true
        }
        return false
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isWebUrlValid(_ urlString: String?) -> Bool {
        if let urlString = urlString, let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func checkOpenLink(_ urlString: String?) {
        let app = UIApplication.shared
        guard let urlString = urlString, let url = URL(string: urlString), app.canOpenURL(url) else {
            showAlert(message: "Invalid Link.")
            return
        }
        app.open(url, options: [:], completionHandler: nil)
    }
    
    func setTabBarVisibility(_ visible: Bool) {
        tabBarController?.tabBar.isHidden = !visible
    }
    
}
