//
//  UdacityClient.swift
//  On the Map
//
//  Created by Cong Doan on 1/3/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit


class UdacityClient: NSObject {
    
    var userInfo: PublicUserInfo!
    
    func authenticateUser(email: String, password: String, completionHandler: @escaping (_ udacityAccountId: String?, _ error: Error?) -> Void) {
        let urlString = "https://www.udacity.com/api/session"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let userAuthCredentails = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        request.httpBody = userAuthCredentails.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            func sendError(_ errorDescription: String) {
                let userInfo = [NSLocalizedDescriptionKey : errorDescription]
                completionHandler(nil, NSError(domain: "authenticateUser", code: 1, userInfo: userInfo))
            }
            
            if let error = error {
                sendError(error.localizedDescription)
                print("ERROR: \(error)")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request.")
                return
            }
            let range = Range(5..<data.count), newData = data.subdata(in: range)
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 200 || statusCode > 299 {
                let errormessage: String!
                if statusCode == 403 || statusCode == 401 {
                    errormessage = "Incorrect Email or Password."
                } else {
                    errormessage = String(data: newData, encoding: .utf8)!
                }
                sendError(errormessage)
                return
            }
            
            // Extract & Save the user's Udacity Account ID
            do {
                let parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String : Any]
                if let account = parsedResult[JSONResponseKeys.account] as? [String:Any] {
                    if let accountId = account[JSONResponseKeys.accountId] as? String {
                        self.userInfo = PublicUserInfo(accountId: accountId, firstName: nil, lastName: nil)
                        completionHandler(accountId, nil)
                    } else {
                        let errormessage = "Could not parse the below dictionary using the key '\(JSONResponseKeys.accountId)':\n\(account)"
                        sendError(errormessage)
                    }
                } else {
                    let errormessage = "Could not parse the below dictionary using the key '\(JSONResponseKeys.account)':\n\(parsedResult)"
                    sendError(errormessage)
                }
            } catch {
                let dataString: String = String(data: newData, encoding: .utf8)!
                let errormessage = "Could not parse the below data as JSON:\n\(dataString)"
                sendError(errormessage)
            }
        }
        task.resume()
    }

    func getPublicUserInfo(accountId: String) {
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(accountId)")!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ERROR: \(error)")
                return
            }
            
            guard let data = data else {
                print("ERROR: No data was returned by the request.")
                return
            }
            let range = Range(5..<data.count), newData = data.subdata(in: range)
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 200 || statusCode > 299 {
                let errormessage = String(data: newData, encoding: .utf8)!
                print("ERROR: Status Code \(statusCode).\n\(errormessage)")
                return
            }
            
            // Extract & Save the user's first and last names
            do {
                let parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String : Any]
                if let user = parsedResult[JSONResponseKeys.user] as? [String:Any] {
                    let firstName = user[JSONResponseKeys.first_name] as? String
                    let lastName = user[JSONResponseKeys.last_name] as? String
                    self.userInfo = PublicUserInfo(accountId: accountId, firstName: firstName, lastName: lastName)
                } else {
                    let errormessage = "Could not parse the below dictionary using the key '\(JSONResponseKeys.user)':\n\(parsedResult)"
                    print(errormessage)
                }
            } catch {
                let dataString: String = String(data: newData, encoding: .utf8)!
                let errormessage = "Could not parse the below data as JSON:\n\(dataString)"
                print(errormessage)
            }
        }
        task.resume()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
