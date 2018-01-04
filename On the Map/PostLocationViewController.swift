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
    
    var placemark: CLPlacemark!
    var mapString: String!
    var mediaURL: String!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Confirm Location"
        showPlacemarkInMap()
    }
    
    func showPlacemarkInMap() {
        let annotation = MKPointAnnotation()
        var addressComponents = [String]()
        if let place = placemark.name {
            addressComponents.append(place)
        }
        if let city = placemark.locality, !addressComponents.contains(city) {
            addressComponents.append(city)
        }
        if let state = placemark.administrativeArea, !addressComponents.contains(state) {
            addressComponents.append(state)
        }
        if let country = placemark.country, !addressComponents.contains(country) {
            addressComponents.append(country)
        }
        mapString = addressComponents.joined(separator: ", ")
        annotation.title = mapString
        annotation.coordinate = placemark.location!.coordinate
        mapView.centerCoordinate = annotation.coordinate
        mapView.addAnnotation(annotation)
    }

    @IBAction func finishButtonPressed(_ sender: Any) {
        // POST or PUT UserLocation object to Parse
        spinner.startAnimating()
        let location = prepareUserLocationObject()
        ParseClient.sharedInstance().postOrPutUserLocation(location) { (success, error) in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
            if let error = error {
                self.showAlert(message: error.localizedDescription, alongsideUIAction: nil)
                return
            }
            self.showAutoCloseAlert(message: "User Location Posted/Updated!") {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func showAutoCloseAlert(message: String, onCloseHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
            
            // duration in seconds
            let duration: Double = 1.5
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                alert.dismiss(animated: true)
                onCloseHandler()
            }
        }
    }
    
    private func prepareUserLocationObject() -> UserLocation {
        let userInfo = UdacityClient.sharedInstance().userInfo!
        let coordinate = placemark.location!.coordinate
        let location = UserLocation(uniqueKey: userInfo.accountId,
                                    firstName: userInfo.firstName, lastName: userInfo.lastName,
                                    mapString: mapString, mediaURL: mediaURL,
                                    latitude: coordinate.latitude, longitude: coordinate.longitude)
        return location
    }
    
}


// MARK: - MKMapViewDelegate

extension PostLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}

