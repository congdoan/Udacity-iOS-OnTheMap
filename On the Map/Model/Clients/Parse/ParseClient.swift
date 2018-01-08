//
//  ParseClient.swift
//  On the Map
//
//  Created by Cong Doan on 1/2/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit

class ParseClient {
    
    // MARK: Shared Instance
    
    static let shared = ParseClient()

    var objectIdOfStudentLocation: String?
    
    private func buildRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue(HeaderFields.appId.value, forHTTPHeaderField: HeaderFields.appId.name)
        request.addValue(HeaderFields.apiKey.value, forHTTPHeaderField: HeaderFields.apiKey.name)
        return request
    }
    
    // Parse API: GET 100 Most Recently Updated Student Locations
    func getUserPins(completionHandler: @escaping (_ userPins: AnyObject?, _ error: Error?) -> Void) {
        let request = buildRequest(url: URL(string: ParseClient.BASE_API_URL + "?limit=100&order=-updatedAt")!)
        startTaskForRequest(request) { (resultDictionary, error) in
            let domain = "ParseClient.getUserPins"
            if let error = error {
                sendError(error.localizedDescription, domain, completionHandler)
                return
            }
            
            // Extract a list of UserPin objects
            let result = resultDictionary!
            if let studentLocations = result[JSONResponseKeys.results] as? [[String:Any]] {
                let userPins = StudentInformation.studentInformationsFromResults(studentLocations)
                completionHandler(userPins as AnyObject, nil)
            } else {
                let errormessage = "Could not parse the below dictionary using the key '\(JSONResponseKeys.results)':\n\(result)"
                sendError(errormessage, domain, completionHandler)
            }
        }
    }
    
    // Parse API: POST or PUT a Student Location
    func postOrPutUserLocation(_ location: StudentLocation,
                               completionHandler: @escaping (_ success: AnyObject?, _ error: Error?) -> Void) {
        var url = URL(string: ParseClient.BASE_API_URL)!
        var httpMethod = "POST"
        if let objectId = ParseClient.shared.objectIdOfStudentLocation {
            url.appendPathComponent(objectId)
            httpMethod = "PUT"
        }
        var request = buildRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue(HeaderFields.contentType.value, forHTTPHeaderField: HeaderFields.contentType.name)
        request.httpBody = location.jsonData
        startTaskForRequest(request) { (resultDictionary, error) in
            if let error = error {
                let domain = "ParseClient.postOrPutUserLocation"
                sendError(error.localizedDescription, domain, completionHandler)
                return
            }
            
            // POST or PUT Success
            completionHandler(true as AnyObject, nil)
        }
    }

}
