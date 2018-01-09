//
//  InputToPostLocationViewController.swift
//  On the Map
//
//  Created by Cong Doan on 1/3/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit
import MapKit

class InputToPostLocationViewController: UIViewController {

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
        if validateInput() && !isNetworkDisconnected() {
            spinner.startAnimating()
            
            geocodeLocationString(completionHandler: { (placemark) in
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                }
                
                if let placemark = placemark {
                    self.openMapForPlace(placemark)
                } else {
                    self.showAlert(message: "Could Not Geocode the Location String.")
                }
            })
        }
    }
    
    private func openMapForPlace(_ placemark: CLPlacemark) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MapForPlaceViewController") as! PostLocationViewController
        controller.placemark = placemark
        controller.mediaURL = websiteField.text
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func validateInput() -> Bool {
        if locationField.text! == "" || websiteField.text! == "" {
            showAlert(message: "Empty Location or Link.")
            return false
        }
        if !isWebUrlValid(websiteField.text) {
            showAlert(message: "Invalid Link. It must start with 'http(s)://'.")
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

extension InputToPostLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
