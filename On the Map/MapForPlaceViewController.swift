//
//  MapForPlaceViewController.swift
//  On the Map
//
//  Created by Cong Doan on 1/3/18.
//  Copyright © 2018 Cong Doan. All rights reserved.
//

import UIKit
import MapKit


class MapForPlaceViewController: UIViewController {
    
    var placemark: CLPlacemark!
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        annotation.title = addressComponents.joined(separator: ", ")
        annotation.coordinate = placemark.location!.coordinate
        mapView.centerCoordinate = annotation.coordinate
        mapView.addAnnotation(annotation)
    }

    @IBAction func finishButtonPressed(_ sender: Any) {
        //TODO: POST or PUT UserLocation object to Parse
        print("PublicUserInfo: \(UdacityClient.sharedInstance().userInfo)")
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}


// MARK: - MKMapViewDelegate

extension MapForPlaceViewController: MKMapViewDelegate {
    
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

