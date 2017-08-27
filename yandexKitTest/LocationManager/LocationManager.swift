//
//  LocationManager.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 26/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import Foundation

//A singletone to store current location data
class LocationManager {
    
    static let shared = LocationManager()
    
    var lat = 49.533877
    var long = 19.750441
    var zoomLevel: UInt = 2
    var name = ""
    var shouldSetAnnotation = false
    
    func setLocationAtPlace(place: Place) {
        lat = place.lat
        long = place.long
        name = place.name
    }
    
}
