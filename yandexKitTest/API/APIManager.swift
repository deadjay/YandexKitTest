//
//  APIManager.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 25/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    private static let BASE_URL               = "https://api-dev.supermenu.kz/address/"
    private static let URL_GET_ADDRESS        = BASE_URL+"clientSearch?query=street="
    private static let URL_GET_BY_COORDINATES = BASE_URL+"clientSearch?"
    private static let URL_GET_NEAREST        = BASE_URL+"clientGeocode?"
    
    private let request = APIRequests()
    private let parser  = APIParser()
    
    private static var sessionManager: SessionManager {
        let sessionManager = Alamofire.SessionManager.default
        return sessionManager
    }
    
    //MARK: Public Methods
    
    //Loads places by giving string
    func loadPlaces(stringParameter: String, onFinish:@escaping([Place]) -> Void) {
        loadMultipleData(url: APIManager.URL_GET_ADDRESS+stringParameter) {
            (places) in
            onFinish(places)
        }
    }
    
    //Loads places by giving coordinates
    func loadPlacesByCoordinates(lon: Double, lat: Double, onFinish:@escaping([Place]) -> Void) {
        loadMultipleData(url: APIManager.URL_GET_BY_COORDINATES+"longitude=\(lon)&latitude=\(lat)") {
            (places) in
            onFinish(places)
        }
    }
    
    //Loads nearest place by giving coordinates
    func loadNearestPlace(lon: Double, lat: Double, onFinish:@escaping(_ place: Place) -> Void) {
        loadSingleData(url: APIManager.URL_GET_NEAREST+"longitude=\(lon)&latitude=\(lat)") {
            (place) in
            onFinish(place)
        }
    }
    
    //MARK: Private Methods
    
    private func loadMultipleData(url: String, completion:@escaping([Place]) -> Void) {
        print("URL = \(url)")
        request.performGETRequest(url: url) { (dataResponse) in
            if let result = self.parser.parsePlaces(data: dataResponse) {
                completion(result)
            }
        }
    }
    
    private func loadSingleData(url: String, completion:@escaping(_ place: Place) -> Void) {
        print("URL = \(url)")
        request.performGETRequest(url: url) { (dataResponse) in
            if let result = self.parser.parseSinglePlace(data: dataResponse) {
                completion(result)
            }
        }
    }
    
}
