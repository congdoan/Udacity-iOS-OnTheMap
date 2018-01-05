//
//  ParseContants.swift
//  On the Map
//
//  Created by Cong Doan on 1/2/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import Foundation


extension ParseClient {
    
    static let BASE_API_URL = "https://parse.udacity.com/parse/classes/StudentLocation"
    
    struct HeaderFields {
        static let appId: (name: String, value: String) = ("X-Parse-Application-Id", "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr")
        static let apiKey: (name: String, value: String) = ("X-Parse-REST-API-Key", "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY")
        static let contentType: (name: String, value: String) = ("Content-Type", "application/json")
    }
    
    struct JSONResponseKeys {
        // MARK: StudentLocation
        static let results = "results"
        static let objectId = "objectId"
        static let uniqueKey =  "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
}
