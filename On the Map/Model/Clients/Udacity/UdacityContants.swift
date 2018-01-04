//
//  UdacityContants.swift
//  On the Map
//
//  Created by Cong Doan on 1/3/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import Foundation


extension UdacityClient {
    
    static let BASE_API_URL = URL(string: "https://www.udacity.com/api")!
    
    struct JSONResponseKeys {
        // MARK: Account
        static let account = "account"
        static let accountId = "key"
        
        // MARK: User
        static let user = "user"
        static let first_name = "first_name"
        static let last_name = "last_name"
    }
    
}
