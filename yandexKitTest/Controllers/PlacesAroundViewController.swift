//
//  PlacesAroundViewController.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 27/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import UIKit

class PlacesAroundViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tableViewRoutineDelegates: TableViewRoutineDelegates!
    
    let apiManager = APIManager()
    var places = [Place]()
    
    
    //UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        loadResults()
    }
    

    //MARK: Methods
    func setupViewController() {
        self.tableViewRoutineDelegates =
            TableViewRoutineDelegates(tableView: tableView, places: places, sender: self)
        tableView.keyboardDismissMode = .onDrag
    }
    
    func loadResults() {
        startSpinner()
        apiManager.loadPlacesByCoordinates(lon: LocationManager.shared.long, lat: LocationManager.shared.lat) { (places) in
            self.tableViewRoutineDelegates.sectionsRowsArray = places
            self.stopSpinner()
            self.tableView.reloadData()
        }
    }
    
    //MARK: UIButton Actions
    @IBAction func cancelButtonDidTapped(_ sender: Any) {
        LocationManager.shared.shouldSetAnnotation = false
        dismiss(animated: true, completion: nil)
    }
}

extension PlacesAroundViewController {
    func startSpinner() {
        tableView.addSubview(tableViewRoutineDelegates.spinner)
        tableViewRoutineDelegates.spinner.startAnimating()
    }
    
    func stopSpinner() {
        tableViewRoutineDelegates.spinner.stopAnimating()
    }
}
