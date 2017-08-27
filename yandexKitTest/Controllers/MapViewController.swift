//
//  MapViewController.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 24/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, YMKLocationFetcherDelegate, YMKMapViewDelegate, PlacesDelegate {
    
    private let searchControllerSegueID = "showSearchController"
    private let placesControllerSegueID = "showPlacesController"
    
    @IBOutlet var mapView: YMKMapView!
    
    private let locationFetcher = YMKLocationFetcher()
    private var annotationPoint: PointAnnotation?
    private var hintView: TapHintView?
    private let apiManager = APIManager()
    private var coordinateOnTap = YMKMapCoordinate()
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        mapView.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mapView.showsUserLocation = true;
        //When we back here, the coordinates might change, so we moving to the new point
        configureAndInstallAnnotation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removePreviousAnnotationPoint()
    }
    
    //MARK: Methods

    func setupViewController() {
        locationFetcher.delegate = self
        mapView.delegate = self
        hintView = TapHintView(frame: .init(x: 0, y: 300, width: 200, height: 300), presentedView: self.view)
        hintView?.delegate = self
        moveToPoint()
    }
    
    func moveToPoint() {
        //Setting default coordinates, when app start firstly
        mapView.setCenter(YMKMapCoordinate.init(latitude: LocationManager.shared.lat,
                                                longitude: LocationManager.shared.long),
                          atZoomLevel: LocationManager.shared.zoomLevel,
                          animated: true)
    }
    
    func loadNearestPlace(lat: Double, lon: Double) {
        apiManager.loadNearestPlace(lon: lon, lat: lat) { (place) in
            LocationManager.shared.setLocationAtPlace(place: place)
            LocationManager.shared.shouldSetAnnotation = true
            self.configureAndInstallAnnotation()
        }
    }
    
    func removePreviousAnnotationPoint() {
        if (annotationPoint != nil) {
            mapView.removeAnnotation(annotationPoint)
            annotationPoint = nil
        }
    }
    
    //MARK: YMKMapViewDelegate
    
    func mapView(_ mapView: YMKMapView!, gotSingleTapAt coordinate: YMKMapCoordinate) {
        coordinateOnTap = coordinate
        LocationManager.shared.lat = coordinate.latitude
        LocationManager.shared.long = coordinate.longitude
        LocationManager.shared.zoomLevel = mapView.zoomLevel
        showInfoAnnotationOnTap(tapCoordinate: coordinate)
        hintView?.showView()
    }
    
    //MARK: Helpers
    
    func configureAndInstallAnnotation() {
        removePreviousAnnotationPoint()
        if !LocationManager.shared.shouldSetAnnotation {
            return
        }
        annotationPoint = PointAnnotation()
        self.annotationPoint!.setCoordinate(YMKMapCoordinate(latitude: LocationManager.shared.lat,
                                                            longitude: LocationManager.shared.long))
        self.annotationPoint!.title = LocationManager.shared.name
        self.mapView.addAnnotation(self.annotationPoint)
        moveToPoint()
    }
    
    func showInfoAnnotationOnTap(tapCoordinate: YMKMapCoordinate) {
        removePreviousAnnotationPoint()
        annotationPoint = PointAnnotation()
        self.annotationPoint!.setCoordinate(YMKMapCoordinate(latitude: tapCoordinate.latitude,
                                                             longitude: tapCoordinate.longitude))
        self.annotationPoint!.title = "\(tapCoordinate.latitude)\(tapCoordinate.longitude)"
        self.mapView.addAnnotation(self.annotationPoint)
        moveToPoint()
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
    
    //MARK: PlacesDelegate
    
    func buttonDidPressed(place: WhichPlace) {
        switch place {
        case .nearestPlace:
            loadNearestPlace(lat: coordinateOnTap.latitude, lon: coordinateOnTap.longitude)
        case .placesAround:
            //setting coordinates into manager, so that in presented controller
            //we can load places by setted coordinates
            LocationManager.shared.lat = coordinateOnTap.latitude
            LocationManager.shared.long = coordinateOnTap.longitude
            performSegue(withIdentifier: placesControllerSegueID, sender: self)
        }
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

