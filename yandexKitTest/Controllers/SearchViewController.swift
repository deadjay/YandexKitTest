//
//  SearchViewController.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 26/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: CustomSearchBar!
    
    var tableViewRoutineDelegates: TableViewRoutineDelegates!
    
    let apiManager = APIManager()
    var places = [Place]()

    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }

    //MARK: Methods
    
    func setupViewController() {
        self.tableViewRoutineDelegates =
            TableViewRoutineDelegates(tableView: tableView, places: places, sender: self)
        searchBar.delegate = self
        searchBar.setShowsCancelButton(false, animated: false)
        tableView.keyboardDismissMode = .onDrag
    }
    
    func loadResults(text: String) {
        startSpinner()
        apiManager.loadPlaces(stringParameter: text) { (loadedPlaces) in
            self.tableViewRoutineDelegates.sectionsRowsArray = loadedPlaces
            self.stopSpinner()
            self.tableView.reloadData()
        }

    }
    
    //MARK: UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            loadResults(text: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            loadResults(text: text)
        }
    }
    
    //MARK: UIButton Actions
    @IBAction func cancelButtonDidTapped(_ sender: Any) {
        LocationManager.shared.shouldSetAnnotation = false
        dismiss(animated: true, completion: nil)
    }

}

extension SearchViewController {
    func startSpinner() {
        tableView.addSubview(tableViewRoutineDelegates.spinner)
        tableViewRoutineDelegates.spinner.startAnimating()
    }
    
    func stopSpinner() {
        tableViewRoutineDelegates.spinner.stopAnimating()
    }
}
