//
//  UserPinViewController.swift
//  On the Map
//
//  Created by Cong Doan on 1/2/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit
import MapKit


class UserMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.startAnimating()
        ParseClient.sharedInstance().getUserPins { (userPins, error) in
            if let userPins = userPins {
                (self.tabBarController as! UserTabBarController).userPins = userPins
                let annotations = self.pointAnnotationsFromUserPins(userPins)
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.mapView.addAnnotations(annotations)
                }
            } else if let error = error {
                self.showAlert(message: error.localizedDescription) {
                    self.spinner.stopAnimating()
                }
            }
        }
    }

    private func pointAnnotationsFromUserPins(_ userPins: [UserPin]) -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for userPin in userPins {
            let annotation = MKPointAnnotation()
            let lat = CLLocationDegrees(userPin.latitude)
            let long = CLLocationDegrees(userPin.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.coordinate = coordinate
            annotation.title = userPin.name
            annotation.subtitle = userPin.mediaURL
            annotations.append(annotation)
        }
        return annotations
    }
    
}


// MARK: - MKMapViewDelegate

extension UserMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            checkOpenLink(view.annotation?.subtitle!)
        }
    }

}