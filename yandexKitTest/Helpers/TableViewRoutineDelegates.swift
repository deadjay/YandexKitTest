//
//  TableViewRoutineDelegates.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 27/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import UIKit

//A class to get rid of TableView delegate and datasource
//*Preventing from MassiveViewController problems*
class TableViewRoutineDelegates: NSObject {
    
    var sectionsRowsArray = [Place]()
    var tableView: UITableView!
    var sender: UIViewController!
    var spinner: UIActivityIndicatorView!
    let screenCenter = CGPoint(x: UIScreen.main.bounds.size.width*0.5,
                            y: UIScreen.main.bounds.size.height*0.4)
    
    init(tableView: UITableView, places: [Place], sender: UIViewController) {
        super.init()
        self.tableView = tableView
        self.sectionsRowsArray = places
        self.sender = sender
        self.tableView.delegate = self
        self.tableView.dataSource = self
        prepareSpinner()
    }
    
    func configureCell(_ cell: UITableViewCell, index: Int) {
        if !sectionsRowsArray.isEmpty {
            cell.textLabel?.text = sectionsRowsArray[index].name
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        }
    }
    
    //Recording coordinates into a singletone
    func setNewCoordinatesFromRow(row: Int) {
        LocationManager.shared.lat = sectionsRowsArray[row].lat
        LocationManager.shared.long = sectionsRowsArray[row].long
        LocationManager.shared.name = sectionsRowsArray[row].name
        LocationManager.shared.zoomLevel = 15
    }
    
    func prepareSpinner() {
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        spinner.center = screenCenter
    }
    
}

//MARK: UITableViewDataSource
extension TableViewRoutineDelegates: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionsRowsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "identifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        configureCell(cell!, index: indexPath.row)
                
        return cell!
    }
    
}

//MARK: UITableViewDelegate
extension TableViewRoutineDelegates: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setNewCoordinatesFromRow(row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        LocationManager.shared.shouldSetAnnotation = true
        sender.dismiss(animated: true, completion: nil)
    }
    
}
