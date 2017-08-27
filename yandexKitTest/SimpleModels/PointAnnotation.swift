//
//  PointAnnotation.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 27/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import Foundation

class PointAnnotation: NSObject, YMKDraggableAnnotation {
    var title = ""
    var subtitle = ""
    var coord = YMKMapCoordinate()
    
    func setCoordinate(_ coordinate: YMKMapCoordinate) {
        self.coord = coordinate
    }
    
    func coordinate() -> YMKMapCoordinate {
        return self.coord
    }
    
    class func pointAnnotation() -> Any {
        return self
    }
}
