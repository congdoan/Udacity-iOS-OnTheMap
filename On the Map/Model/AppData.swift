//
//  AppData.swift
//  On the Map
//
//  Created by Cong Doan on 1/8/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

class AppData {
    
    static let shared = AppData()
    
    var userInfo: PublicUserInfo!
    
    var objectIdOfUserLocation: String?
    
    var userPins = [UserPin]()
    
    func setUserPins(_ newUserPins: [UserPin], observers: [TabItemViewController]) {
        userPins = newUserPins
        for tabItemViewController in observers {
            tabItemViewController.hideDataFetchingIndicator()
            tabItemViewController.updateUI()
        }
    }

}
