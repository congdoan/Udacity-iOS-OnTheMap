//
//  UIViewController+extentions.swift
//  On the Map
//
//  Created by Cong Doan on 1/3/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func showAlert(message: String, alongsideUIAction: (() -> Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(action)
        DispatchQueue.main.async {
            alongsideUIAction?()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkOpenLink(_ urlString: String?) {
        let app = UIApplication.shared
        guard let urlString = urlString, let url = URL(string: urlString), app.canOpenURL(url) else {
            showAlert(message: "Invalid Link", alongsideUIAction: nil)
            return
        }
        app.open(url, options: [:], completionHandler: nil)
    }
    
}
