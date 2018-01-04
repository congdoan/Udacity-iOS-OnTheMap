//
//  ParseClient.swift
//  On the Map
//
//  Created by Cong Doan on 1/2/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit

class ParseClient: NSObject {
    
    var objectIdOfUserLocation: String?

    // Parse API: GET Student Locations
    func getUserPins(completionHandler: @escaping (_ results: [UserPin]?, _ error: Error?) -> Void) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation", url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            func sendError(_ errorDescription: String) {
                let userInfo = [NSLocalizedDescriptionKey : errorDescription]
                completionHandler(nil, NSError(domain: "ParseClient.getUserPins", code: 1, userInfo: userInfo))
            }
            
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request.")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 200 || statusCode > 299 {
                let dataString: String = String(data: data, encoding: .utf8)!
                let errormessage = "HTTP Status Code \(statusCode).\n\(dataString)"
                sendError(errormessage)
                return
            }
            
            do {
                let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                if let results = parsedResult[JSONResponseKeys.results] as? [[String:Any]] {
                    let userPins = UserPin.userPinsFromResults(results)
                    completionHandler(userPins, nil)
                } else {
                    let errormessage = "Could not parse the below dictionary using the key '\(JSONResponseKeys.results)':\n\(parsedResult)"
                    sendError(errormessage)
                }
            } catch {
                let dataString: String = String(data: data, encoding: .utf8)!
                let errormessage = "Could not parse the below data as JSON:\n\(dataString)"
                sendError(errormessage)
            }
        }
        task.resume()
    }
    
    // Parse API: POST or PUT a Student Location
    func postOrPutUserLocation(_ location: UserLocation, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        var url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
        var httpMethod = "POST"
        if let objectId = objectIdOfUserLocation {
            url.appendPathComponent(objectId)
            httpMethod = "PUT"
        }
        print("postOrPutUserLocation URL = ", url)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = location.jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            func sendError(_ errorDescription: String) {
                let userInfo = [NSLocalizedDescriptionKey : errorDescription]
                completionHandler(false, NSError(domain: "ParseClient.postOrPutUserLocation", code: 1, userInfo: userInfo))
            }
            
            if let error = error {
                completionHandler(false, error)
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request.")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 200 || statusCode > 299 {
                let dataString: String = String(data: data, encoding: .utf8)!
                let errormessage = "HTTP Status Code \(statusCode).\n\(dataString)"
                sendError(errormessage)
                return
            }
            
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }

}
