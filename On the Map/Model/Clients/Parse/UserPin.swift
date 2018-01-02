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
        for result in results {
            if let lat = result[ParseClient.JSONResponseKeys.latitude] as? Double, let lon = result[ParseClient.JSONResponseKeys.longitude] as? Double {
                let firstName = result[ParseClient.JSONResponseKeys.firstName]
                let lastName = result[ParseClient.JSONResponseKeys.lastName]
                let name = "\(firstName ?? "No First Name") \(lastName ?? "No Last Name")"
                let mediaURL = "\(result[ParseClient.JSONResponseKeys.mediaURL] ?? "No Media URL")"
                let userPin = UserPin(name: name, mediaURL: mediaURL, latitude: lat, longitude: lon)
                userPins.append(userPin)
            }
        }
        
        return userPins
    }

}
