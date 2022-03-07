//
//  NMAPImanager.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/28.
//

import Foundation
import NMapsMap

class NMManager {
    static let shared = NMManager()
    
    var marker: [Marker]?
    
    typealias CompletionHandler = () -> ()
    
    func drawMarkerOnMap(marker: NMFMarker, lat: Double, lng: Double, result: @escaping CompletionHandler) {
        
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.iconImage = NMFOverlayImage(name: "Group2")
        marker.width = 20
        marker.height = 20
    }
}
