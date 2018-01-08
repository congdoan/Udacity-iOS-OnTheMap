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
    
    init?(_ result: [String:Any]) {
        if let lat = result[ParseClient.JSONResponseKeys.latitude] as? Double, let lon = result[ParseClient.JSONResponseKeys.longitude] as? Double {
            let firstName = result[ParseClient.JSONResponseKeys.firstName]
            let lastName = result[ParseClient.JSONResponseKeys.lastName]
            name = "\(firstName ?? "No First Name") \(lastName ?? "No Last Name")"
            mediaURL = "\(result[ParseClient.JSONResponseKeys.mediaURL] ?? "No Media URL")"
            latitude = lat
            longitude = lon
        } else {
            return nil
        }
    }
    
    
    static func userPinsFromResults(_ results: [[String:Any]]) -> [UserPin] {
        var userPins = [UserPin]()
        
        // Iterate through array of dictionaries, each UserPin is a dictionary
        let udacityAccoundId = AppData.shared.userInfo.accountId
        for result in results {
            if let userPin = UserPin(result) {
                userPins.append(userPin)
                
                if let uniqueKey = result[ParseClient.JSONResponseKeys.uniqueKey] as? String, uniqueKey == udacityAccoundId {
                    AppData.shared.objectIdOfUserLocation = (result[ParseClient.JSONResponseKeys.objectId] as! String)
                }
            }
        }

        return userPins
    }

}
