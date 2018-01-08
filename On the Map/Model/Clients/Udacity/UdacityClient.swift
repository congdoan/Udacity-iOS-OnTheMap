//
//  UdacityClient.swift
//  On the Map
//
//  Created by Cong Doan on 1/3/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit

class UdacityClient {
    
    func authenticateUser(email: String, password: String,
                          completionHandler: @escaping (_ accountId: AnyObject?, _ error: Error?) -> Void) {
        var request = URLRequest(url: UdacityClient.BASE_API_URL.appendingPathComponent("session"))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let credentailsDictionary = ["udacity" : ["username" : email, "password" : password]]
        request.httpBody = try! JSONSerialization.data(withJSONObject: credentailsDictionary, options: .prettyPrinted)
        startTaskForRequest(request, requestToUdacityApi: true) { (resultDictionary, error) in
            let domain = "UdacityClient.authenticateUser"
            if let error = error {
                var errorMessage = error.localizedDescription
                if errorMessage.starts(with: "Status Code 403.") || errorMessage.starts(with: "Status Code 401.") {
                    errorMessage = "Invalid Email or Password."
                }
                sendError(errorMessage, domain, completionHandler)
                return
            }
            
            /* Extract the User's Udacity Account ID */
            let result = resultDictionary!
            //print("Login's Result: \(result)\n****************************************************")
            if let account = result[JSONResponseKeys.account] as? [String:Any] {
                if let accountId = account[JSONResponseKeys.accountId] as? String {
                    completionHandler(accountId as AnyObject, nil)
                } else {
                    let errorMessage = "Could not parse the below dictionary using the key '\(JSONResponseKeys.accountId)':\n\(account)"
                    sendError(errorMessage, domain, completionHandler)
                }
            } else {
                let errorMessage = "Could not parse the below dictionary using the key '\(JSONResponseKeys.account)':\n\(result)"
                sendError(errorMessage, domain, completionHandler)
            }
        }
    }

    func getPublicUserInfo(accountId: String,
                           completionHandler: @escaping (_ accountId: AnyObject?, _ error: Error?) -> Void) {
        let request = URLRequest(url: UdacityClient.BASE_API_URL.appendingPathComponent("users/\(accountId)"))
        startTaskForRequest(request, requestToUdacityApi: true) { (resultDictionary, error) in
            let domain = "UdacityClient.getPublicUserInfo"
            if let error = error {
                sendError(error.localizedDescription, domain, completionHandler)
                return
            }
            
            /* Extract the User's First and Last Names */
            let result = resultDictionary!
            if let user = result[JSONResponseKeys.user] as? [String:Any] {
                let firstName = user[JSONResponseKeys.first_name] as? String
                let lastName = user[JSONResponseKeys.last_name] as? String
                let userInfo = PublicUserInfo(accountId: accountId, firstName: firstName, lastName: lastName) as AnyObject
                completionHandler(userInfo, nil)
            } else {
                let errormessage = "Could not parse the below dictionary using the key '\(JSONResponseKeys.user)':\n\(result)"
                sendError(errormessage, domain, completionHandler)
                print(errormessage)
            }
        }
    }

    func logout(completionHandler: @escaping (_ success: AnyObject?, _ error: Error?) -> Void) {
        var request = URLRequest(url: UdacityClient.BASE_API_URL.appendingPathComponent("session"))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        for cookie in HTTPCookieStorage.shared.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            //print("X-XSRF-TOKEN: \(request.value(forHTTPHeaderField: "X-XSRF-TOKEN")!)\n****************************************************")
        }
        
        startTaskForRequest(request, requestToUdacityApi: true) { (resultDictionary, error) in
            let domain = "UdacityClient.logout"
            if let error = error {
                sendError(error.localizedDescription, domain, completionHandler)
                return
            }
            
            //print("Logout's Result: \(resultDictionary!)")
            let successfulDeletingTheSession = true
            completionHandler(successfulDeletingTheSession as AnyObject, nil)
        }
    }

    // MARK: Shared Instance
    
    static let shared = UdacityClient()
    
}
