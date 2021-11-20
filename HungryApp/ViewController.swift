//
//  ViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/20.
//

import UIKit
import NMapsMap

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    
    let coord = NMGLatLng(lat: 37.5670135, lng: 126.9783740)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // setMapView()
    }
    
    func setMapView() {
        let mapView = NMFMapView(frame: view.frame)
        
        mapView.mapType = .basic
        mapView.isNightModeEnabled = true
        
        self.view.addSubview(mapView)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
    
}

