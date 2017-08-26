//
//  SearchViewController.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 26/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: CustomSearchBar!
    
    private let PLACE_ZOOM_LEVEL: UInt = 15
    let apiManager = APIManager()
    var places = [Place]()

    
    //MARK: ViewController Lidecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }

    //MARK: Methods
    
    func setupViewController() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.setShowsCancelButton(false, animated: false)
    }
    
    func loadResults(text: String) {
        apiManager.loadPlaces(stringParameter: text) { (loadedPlaces) in
            self.places = loadedPlaces
            print("loadResults PLACES COUNT = \(self.places.count)")
            self.reloadTableView()
        }

    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func configureCell(cell: UITableViewCell, index: Int) {
        if !places.isEmpty {
            cell.textLabel?.text = places[index].name
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        }
    }
    
    func setNewCoordinatesFromRow(row: Int) {
        print("Index = \(row) places count = \(places.count)")
        LocationManager.shared.lat = places[row].lat
        LocationManager.shared.long = places[row].long
        LocationManager.shared.name = places[row].name
        //Recording our preferable zoom level into a singletone
        LocationManager.shared.zoomLevel = PLACE_ZOOM_LEVEL
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "identifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        configureCell(cell: cell!, index: indexPath.row)
        
        return cell!
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Setting selected coordinates into a singletone to proceed it later
        setNewCoordinatesFromRow(row: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            loadResults(text: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            reloadTableView()
            loadResults(text: text)
        }
    }
    
    //MARK: UIButton Actions
    @IBAction func cancelButtonDidTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
