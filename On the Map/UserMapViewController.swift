//
//  UserMapViewController.swift
//  On the Map
//
//  Created by Cong Doan on 1/2/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit
import MapKit


class UserMapViewController: TabItemViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    override func showDataFetchingIndicator() {
        spinner.startAnimating()
    }
    
    override func hideDataFetchingIndicator() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    override func updateUI() {
        let annotations = pointAnnotationsFromUserPins((tabBarController as! UserTabBarController).userPins)
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
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
            if isNetworkDisconnected() {
                return
            }
            
            checkOpenLink(view.annotation?.subtitle!)
        }
    }

}
