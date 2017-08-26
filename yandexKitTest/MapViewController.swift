//
//  MapViewController.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 24/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, YMKLocationFetcherDelegate {
    
    private let searchControllerSegueID = "showSearchController"
    
    @IBOutlet var mapView: YMKMapView!
    
    let locationFetcher = YMKLocationFetcher()
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mapView.showsUserLocation = true;
        //When we back here (viewDidAppear), the coordinates might change, so we moving to the new point
        moveToPoint()
    }
    
    //MARK: Methods

    func setupViewController() {
        locationFetcher.delegate = self
        moveToPoint()
    }
    
    func moveToPoint() {
        //Setting default coordinates, when app start firstly
        mapView.setCenter(YMKMapCoordinate.init(latitude: LocationManager.shared.lat,
                                                longitude: LocationManager.shared.long),
                          atZoomLevel: LocationManager.shared.zoomLevel,
                          animated: true)
    }
    
    //MARK: YMKLocationFetcherDelegate
    
    func locationFetcherDidFetchUserLocation(_ locationFetcher: YMKLocationFetcher!) {
        scrollToUserLocation()
    }
    
    func locationFetcher(_ locationFetcher: YMKLocationFetcher!, didFailWithError error: Error!) {
        if error != nil {
            notifyUserLocationError(error: error)
        }
    }
    
    func scrollToUserLocation() {
        if let userLocation = mapView.userLocation.location {
            mapView.setCenter(userLocation.coordinate, atZoomLevel: 15, animated: true)
        }
    }
    
    func notifyUserLocationError(error: Error) {
        let alertView = UIAlertController(title: "Unable To Fetch User Location",
                                          message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: { (alert) in})
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    //MARK: UIButton Actions
    @IBAction func searchButtonDidTapped(_ sender: Any) {
        performSegue(withIdentifier: searchControllerSegueID, sender: self)
    }
    
    @IBAction func locationButtonDidTapped(_ sender: Any) {
        locationFetcher.acquireUserLocationFromMapView()
        scrollToUserLocation()
    }
}

