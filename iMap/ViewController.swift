//
//  ViewController.swift
//  iMap
//
//  Created by Alexander Amelkin on 25.09.2020.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var coordinate = CLLocationCoordinate2D(latitude: 55.797565, longitude: 37.960515)
    var locationManager: CLLocationManager?
    var marker: GMSMarker?
    var speed = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
    }

    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        mapView.isTrafficEnabled    = true
        mapView.mapType             = .hybrid
        mapView.camera              = camera
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
    }
    
    func addMarker() {
        let marker      = GMSMarker(position: coordinate)
        marker.title    = String(speed)+" MPH"
        marker.icon     = GMSMarker.markerImage(with: .random)
        marker.map      = mapView
        self.marker     = marker
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location  = locations.first else { return }
        
        let position    = GMSCameraPosition(target: location.coordinate, zoom: 15)
        self.speed      = location.speed
        self.coordinate = location.coordinate
        
        self.mapView.animate(to: position)
        self.addMarker()
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
