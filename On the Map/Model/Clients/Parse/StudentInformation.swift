//
//  StudentInformation.swift
//  On the Map
//
//  Created by Cong Doan on 1/2/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    static var studentInfos = [StudentInformation]()
    
    static func setStudentInfos(_ newStudentInfos: [StudentInformation], observers: [TabItemViewController]) {
        studentInfos = newStudentInfos
        for tabItemViewController in observers {
            tabItemViewController.hideDataFetchingIndicator()
            tabItemViewController.updateUI()
        }
    }
    
    
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
    
    
    static func studentInformationsFromResults(_ results: [[String:Any]]) -> [StudentInformation] {
        var userPins = [StudentInformation]()
        
        // Iterate through array of dictionaries, each UserPin is a dictionary
        let udacityAccoundId = UdacityClient.shared.userInfo.accountId
        for result in results {
            if let userPin = StudentInformation(result) {
                userPins.append(userPin)
                
                if let uniqueKey = result[ParseClient.JSONResponseKeys.uniqueKey] as? String, uniqueKey == udacityAccoundId {
                    ParseClient.shared.objectIdOfStudentLocation = (result[ParseClient.JSONResponseKeys.objectId] as! String)
                }
            }
        }

        return userPins
    }

}
