//
//  APIParser.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 25/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import Foundation
import Alamofire

private extension APIParser {
    //Method to tear down optional "pyramid of doom"
    func if_let<T, U, V, W>(a: Optional<Any>, b: Optional<Any>,
                c: Optional<Any>, d: Optional<Any>, fn: (T, U, V, W) -> ()) {
        if let a = a as? T {
            if let b = b as? U {
                if let c = c as? V {
                    if let d = d as? W{
                    fn(a, b, c, d)
                    }
                }
            }
        }
    }
}

class APIParser {
    
    //MARK: Public Methods
    
    func parseReceivedData(data: DataResponse<Any>) -> Array<Place>? {
        if let json = data.result.value {
            if let jsonResult = json as? Dictionary<String, AnyObject> {
                return fetchPlaces(data: jsonResult)
            }
        }
        return nil
    }
    
    //MARK: Private Methods
    
    private func fetchPlaces(data: Dictionary<String, AnyObject>) -> Array<Place>? {
        if let data = data["data"] as? Array<[String : Any]> {
            var places = [Place]()
            for obj in data {
                if_let(a: obj["id"], b: obj["name"], c: obj["latitude"], d: obj["longitude"],
                       fn: { (id: Int, name: String, lat: Double, lon: Double) in
                        let place = Place(id: id, name: name, lat: lat, long: lon)
                        places.append(place)
                })
            }
            return places
        }
        return nil
    }
    
}
