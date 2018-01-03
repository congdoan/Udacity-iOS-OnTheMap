//
//  ViewController.swift
//  On the Map
//
//  Created by Cong Doan on 1/1/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var signUpLinkRange: NSRange!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIControls()
    }
    
    fileprivate func configureUIControls() {
        emailField.delegate = self
        
        passwordField.delegate = self
        passwordField.isSecureTextEntry = true
        
        logInButton.isEnabled = false
        
        let signUpPrefix = "Don't have an account? ", signUpSuffix = "Sign Up"
        signUpLinkRange = NSRange(location: signUpPrefix.count, length: signUpSuffix.count)
        let attributedString = NSMutableAttributedString(string: "\(signUpPrefix)\(signUpSuffix)")
        let lightBlue = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        attributedString.addAttribute(.foregroundColor, value: lightBlue, range: signUpLinkRange)
        signUpLabel.attributedText = attributedString
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(signUpLinkTapped))
        signUpLabel.addGestureRecognizer(tapGestureRecognizer)
        signUpLabel.isUserInteractionEnabled = true
    }
    
    @IBAction func logInButtonPressed(sender: Any) {
        authenticateUser()
    }
    
    fileprivate func authenticateUser() {
        if Reachability.isNotConnected() {
            showAlert(message: "The Internet connection appears to be offline.", alongsideUIAction: nil)
            return
        }
        
        spinner.startAnimating()
        
        let urlString = "https://www.udacity.com/api/session"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let email = emailField.text!, password = passwordField.text!
        let userAuthCredentails = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        request.httpBody = userAuthCredentails.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.showAlertWithStopSpinner(message: error.localizedDescription)
                print("ERROR: \(error)")
                return
            }
            
            guard let data = data else {
                self.showAlertWithStopSpinner(message: "No data was returned by the request.")
                return
            }
            let range = Range(5..<data.count), newData = data.subdata(in: range)
            let resultJsonString = String(data: newData, encoding: .utf8)!
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 200 || statusCode > 299 {
                let message: String!
                if statusCode == 403 || statusCode == 401 {
                    message = "Incorrect Email or Password."
                } else {
                    message = resultJsonString
                }
                self.showAlertWithStopSpinner(message: message)
                return
            }
            
            self.showMainView()
        }
        task.resume()
    }
    
    private func showMainView() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapListTabBarController")
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            // Present 'Map & List Tabbed View Controller'
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private func showAlertWithStopSpinner(message: String) {
        showAlert(message: message) {
            self.spinner.stopAnimating()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordField && logInButton.isEnabled {
            authenticateUser()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == emailField {
            logInButton.isEnabled = (newText.trimmingCharacters(in: .whitespaces)  != "") && (passwordField.text! != "")
        } else {
            logInButton.isEnabled = (emailField.text!.trimmingCharacters(in: .whitespaces) != "") && (newText != "")
        }
        return true
    }
    
    @objc func signUpLinkTapped(gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(signUpLabel, inRange: signUpLinkRange) {
            if Reachability.isNotConnected() {
                showAlert(message: "The Internet connection appears to be offline.", alongsideUIAction: nil)
                return
            }
            
            let signUpURL = URL(string: "https://auth.udacity.com/sign-up")!
            UIApplication.shared.open(signUpURL, options: [:], completionHandler: nil)
        }
    }

}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(_ label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                            in: textContainer,
                                                            fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
