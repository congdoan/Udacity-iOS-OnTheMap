//
//  CommonClient.swift
//  On the Map
//
//  Created by Cong Doan on 1/5/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import Foundation

func sendError(_ errorDescription: String,
               _ domain: String,
               _ recipientCompletionHandler: (_ result: AnyObject?, _ error: Error?) -> Void) {
    let userInfo = [NSLocalizedDescriptionKey : errorDescription]
    recipientCompletionHandler(nil, NSError(domain: domain, code: 1, userInfo: userInfo))
}

func startTaskForRequest(_ request: URLRequest,
                         requestToUdacityApi: Bool = false,
                         completionHandler: @escaping (_ resultDictionary: AnyObject?, _ error: Error?) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        let domain = "startTaskForRequest"
        
        if let error = error {
            sendError(error.localizedDescription, domain, completionHandler)
            print("ERROR: \(error)")
            return
        }
        
        guard var data = data else {
            sendError("No data was returned by the request.", domain, completionHandler)
            return
        }
        
        if requestToUdacityApi {
            let range = Range(5..<data.count)
            data = data.subdata(in: range)
        }
        
        if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 200 || statusCode > 299 {
            let errormessage = "Status Code \(statusCode). " + String(data: data, encoding: .utf8)!
            sendError(errormessage, domain, completionHandler)
            return
        }
        
        do {
            let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            completionHandler(parsedResult, nil)
        } catch {
            let dataString: String = String(data: data, encoding: .utf8)!
            let errormessage = "Could not parse the below data as JSON:\n\(dataString)"
            sendError(errormessage, domain, completionHandler)
        }
    }
    task.resume()
}

