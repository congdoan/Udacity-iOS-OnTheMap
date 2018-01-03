//
//  PostLocationViewController.swift
//  On the Map
//
//  Created by Cong Doan on 1/3/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit
import MapKit


class PostLocationViewController: UIViewController {

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Post Location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(popNavigationStack))
        
        setTabBarVisibility(false)
    }
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        if validateInput() {
            geocodeLocationString(completionHandler: { (placemark) in
                if let placemark = placemark {
                    self.openMapForPlace(placemark)
                } else {
                    self.showAlert(message: "Could Not Geocode the Location String.", alongsideUIAction: nil)
                }
            })
        }
    }
    
    private func openMapForPlace(_ placemark: CLPlacemark) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MapForPlaceViewController") as! MapForPlaceViewController
        controller.placemark = placemark
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func validateInput() -> Bool {
        if locationField.text! == "" || websiteField.text! == "" {
            showAlert(message: "Empty Location or Link.", alongsideUIAction: nil)
            return false
        }
        if !isWebUrlValid(websiteField.text) {
            showAlert(message: "Invalid Link. It must start with 'http(s)://'.", alongsideUIAction: nil)
            return false
        }
        return true
    }
    
    func geocodeLocationString(completionHandler: @escaping (CLPlacemark?) -> Void) {
        let addressString = locationField.text!
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard error == nil else {
                print("Geocoding Error: \(error!)")
                completionHandler(nil)
                return
            }
            completionHandler(placemarks?.first)
        }
    }
    
    @objc func popNavigationStack() {
        navigationController?.popViewController(animated: true)
    }

}
