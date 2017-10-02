//
//  ViewController.swift
//  BeApp_Velib
//
//  Created by Florian Baudin on 28/09/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {

    private let stationManager:StationManager = StationManager()
    var stations:[Station] = [Station]()
    var filteredStations:[Station] = [Station]()
    let searchController = UISearchController(searchResultsController: nil)
    var openedStations:[Station] = [Station]()
    var closedStations:[Station] = [Station]()
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func changedSegmentedChoice(_ sender: Any) {
        
        if isFiltering(){

            sortStations(stations: filteredStations)
            tableView.reloadData()
        }else {

            sortStations(stations: stations)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationManager.loadStation(completion: receiveStations)
        
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchView.addSubview(searchController.searchBar)
    }

    private func receiveStations(_ stations: [Station]) {
        self.stations = stations
        
        sortStations(stations: stations)
        
        tableView.reloadData()
    }
    
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                return filteredStations.count
            case 1:
                return openedStations.count
            case 2:
                return closedStations.count
            default :
                return 1
            }
            
        } else {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                return stations.count
            case 1:
                return openedStations.count
            case 2:
                return closedStations.count
            default:
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell")!
        
        if isFiltering() {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                cell.textLabel!.text = filteredStations[indexPath.row].name!
            case 1:
                cell.textLabel!.text = openedStations[indexPath.row].name!
            case 2:
                cell.textLabel!.text = closedStations[indexPath.row].name!
            default :
                cell.textLabel!.text = "Error"
            }
        } else {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                cell.textLabel!.text = stations[indexPath.row].name!
            case 1:
                cell.textLabel!.text = openedStations[indexPath.row].name!
            case 2:
                cell.textLabel!.text = closedStations[indexPath.row].name!
            default :
                cell.textLabel!.text = "Error"
            }
        }
        
        return cell
    }

    //MARK : Search Bar
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!.lowercased())
        sortStations(stations: filteredStations)
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredStations = stations.filter({( station : Station) -> Bool in
            return station.name!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    //MARK : SegmentedControl
    
    func sortStations(stations: [Station]) {
        
        openedStations = []
        closedStations = []
        
        for station in stations {
            if station.status == "OPEN"{
                openedStations.append(station)
            }else {
                closedStations.append(station)
            }
        }
        
        tableView.reloadData()
    }
    
}

