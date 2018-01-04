//
//  UserLocation.swift
//  On the Map
//
//  Created by Cong Doan on 1/3/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import Foundation


struct UserLocation {
    
    let uniqueKey: String
    let firstName: String?
    let lastName: String?
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double

    var jsonData: Data {
        let firstName = self.firstName ?? "[No First Name]"
        let lastName = self.lastName ?? "[No Last Name]"
        let dict: [String:Any] = ["uniqueKey":uniqueKey,
                                  "firstName":firstName, "lastName":lastName,
                                  "mapString":mapString, "mediaURL":mediaURL,
                                  "latitude":latitude, "longitude":longitude]
        return try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
    }

}
