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
    
    private func sendError(_ errorDescription: String,
                           _ statusCode: Int?,
                           _ domain: String,
                           _ recipientCompletionHandler: (_ result: AnyObject?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let userInfo = [NSLocalizedDescriptionKey : errorDescription]
        recipientCompletionHandler(nil, NSError(domain: domain, code: 1, userInfo: userInfo), statusCode)
    }
    
    private func startTaskForRequest(_ request: URLRequest,
                                     completionHandler: @escaping (_ resultDictionary: AnyObject?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            let domain = "startTaskForRequest"
            
            if let error = error {
                self.sendError(error.localizedDescription, statusCode, domain, completionHandler)
                print("ERROR: \(error)")
                return
            }
            
            guard let data = data else {
                self.sendError("No data was returned by the request.", statusCode, domain, completionHandler)
                return
            }
            let range = Range(5..<data.count), newData = data.subdata(in: range)
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 200 || statusCode > 299 {
                self.sendError(String(data: newData, encoding: .utf8)!, statusCode, domain, completionHandler)
                return
            }
            
            do {
                let parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
                completionHandler(parsedResult, nil, statusCode)
            } catch {
                let dataString: String = String(data: newData, encoding: .utf8)!
                let errormessage = "Could not parse the below data as JSON:\n\(dataString)"
                self.sendError(errormessage, statusCode, domain, completionHandler)
            }
        }
        task.resume()
    }
    
    func authenticateUser(email: String, password: String,
                          completionHandler: @escaping (_ accountId: AnyObject?, _ error: Error?, _ statusCode: Int?) -> Void) {
        var request = URLRequest(url: UdacityClient.BASE_API_URL.appendingPathComponent("session"))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let credentailsDictionary = ["udacity" : ["username" : email, "password" : password]]
        request.httpBody = try! JSONSerialization.data(withJSONObject: credentailsDictionary, options: .prettyPrinted)
        startTaskForRequest(request) { (resultDictionary, error, statusCode) in
            let domain = "authenticateUser"
            if let error = error {
                let errormessage: String!
                if let statusCode = statusCode, statusCode == 403 || statusCode == 401 {
                    errormessage = "Incorrect Email or Password."
                } else {
                    errormessage = error.localizedDescription
                }
                self.sendError(errormessage, statusCode, domain, completionHandler)
                return
            }
            
            // Extract the User's Udacity Account ID
            let result = resultDictionary!
            if let account = result[JSONResponseKeys.account] as? [String:Any] {
                if let accountId = account[JSONResponseKeys.accountId] as? String {
                    completionHandler(accountId as AnyObject, nil, statusCode)
                } else {
                    let errormessage = "Could not parse the below dictionary using the key '\(JSONResponseKeys.accountId)':\n\(account)"
                    self.sendError(errormessage, statusCode, domain, completionHandler)
                }
            } else {
                let errormessage = "Could not parse the below dictionary using the key '\(JSONResponseKeys.account)':\n\(result)"
                self.sendError(errormessage, statusCode, domain, completionHandler)
            }
        }
    }

    func getPublicUserInfo(accountId: String,
                           completionHandler: @escaping (_ accountId: AnyObject?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let request = URLRequest(url: UdacityClient.BASE_API_URL.appendingPathComponent("users/\(accountId)"))
        startTaskForRequest(request) { (resultDictionary, error, statusCode) in
            let domain = "getPublicUserInfo"
            if let error = error {
                self.sendError(error.localizedDescription, statusCode, domain, completionHandler)
                return
            }
            
            // Extract the User's First and Last Names
            let result = resultDictionary!
            if let user = result[JSONResponseKeys.user] as? [String:Any] {
                let firstName = user[JSONResponseKeys.first_name] as? String
                let lastName = user[JSONResponseKeys.last_name] as? String
                let userInfo = PublicUserInfo(accountId: accountId, firstName: firstName, lastName: lastName) as AnyObject
                completionHandler(userInfo, nil, statusCode)
            } else {
                let errormessage = "Could not parse the below dictionary using the key '\(JSONResponseKeys.user)':\n\(result)"
                self.sendError(errormessage, statusCode, domain, completionHandler)
                print(errormessage)
            }
        }
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
