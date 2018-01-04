//
//  UserLoginViewController.swift
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
    
    private func configureUIControls() {
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
        if isNetworkDisconnected() {
            return
        }
        
        authenticateUser()
    }
    
    private func authenticateUser() {
        spinner.startAnimating()
        
        let email = emailField.text!, password = passwordField.text!
        let udacityClient = UdacityClient.sharedInstance()
        udacityClient.authenticateUser(email: email, password: password) { (accountId, error) in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
            
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else {
                udacityClient.getPublicUserInfo(accountId: accountId!)
                self.showMainView()
            }
        }
    }
    
    // Present 'Map & List Tabbed View Controller'
    private func showMainView() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapListTabBarController")
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
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
            if isNetworkDisconnected() {
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
