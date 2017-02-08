//
//  MapViewController.swift
//  NoteTaking
//
//  Created by donghyun kim on 2016-12-24.
//  Copyright © 2016 donghyun kim. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps


class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var myView: UIView!
    let locationManager = CLLocationManager()
    var mapView = GMSMapView()
    var camera = GMSCameraPosition()
    
    var currentLat: CLLocationDegrees? = nil
    var currentLng: CLLocationDegrees? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }

        // Do any additional setup after loading the view.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
        self.locationManager.stopUpdatingLocation()
    }
 
    
    func showCurrentLocationOnMap() {
        let camera = GMSCameraPosition.camera(withLatitude: self.currentLat!, longitude: self.currentLng!, zoom: 15)
        let mapView = GMSMapView.map(withFrame: CGRect(x:0, y:0, width:self.myView.frame.size.width, height:self.myView.frame.size.height), camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Current Location"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        self.myView.addSubview(mapView)
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
