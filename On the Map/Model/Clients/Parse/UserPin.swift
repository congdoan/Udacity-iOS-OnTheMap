//
//  UserPin.swift
//  On the Map
//
//  Created by Cong Doan on 1/2/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import Foundation

struct UserPin {
    
    let name: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
    
    static func userPinsFromResults(_ results: [[String:Any]]) -> [UserPin] {
        var userPins = [UserPin]()
        
        // Iterate through array of dictionaries, each UserPin is a dictionary
        let udacityAccoundId = UdacityClient.sharedInstance().userInfo.accountId
        let parseClient = ParseClient.sharedInstance()
        var emptyNameCount = 0, myPostedLocationCount = 0
        for result in results {
            if result[ParseClient.JSONResponseKeys.firstName] == nil || result[ParseClient.JSONResponseKeys.lastName] == nil {
                emptyNameCount += 1
                print(result)
            }
            
            if let lat = result[ParseClient.JSONResponseKeys.latitude] as? Double, let lon = result[ParseClient.JSONResponseKeys.longitude] as? Double {
                let firstName = result[ParseClient.JSONResponseKeys.firstName]
                let lastName = result[ParseClient.JSONResponseKeys.lastName]
                let name = "\(firstName ?? "No First Name") \(lastName ?? "No Last Name")"
                let mediaURL = "\(result[ParseClient.JSONResponseKeys.mediaURL] ?? "No Media URL")"
                let userPin = UserPin(name: name, mediaURL: mediaURL, latitude: lat, longitude: lon)
                userPins.append(userPin)
                
                if let uniqueKey = result[ParseClient.JSONResponseKeys.uniqueKey] as? String, uniqueKey == udacityAccoundId {
                    parseClient.objectIdOfStudentLocationOfCurrentUser = (result[ParseClient.JSONResponseKeys.objectId] as! String)
                    myPostedLocationCount += 1
                }
            }
        }
        print("# of results  : \(results.count)")
        print("# of userPins : \(userPins.count)")
        print("emptyNameCount: \(emptyNameCount)")
        print("myPostedLocationCount                 : \(myPostedLocationCount)")
        print("objectIdOfStudentLocationOfCurrentUser: \(parseClient.objectIdOfStudentLocationOfCurrentUser ?? "nil")")

        return userPins
    }

}
