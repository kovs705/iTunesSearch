//
//  ViewController.swift
//  iTunesSearch
//
//  Created by Kovs on 30.04.2023.
//

import UIKit
import AppleiTunesSearchURLComponents
import CoreMedia

class ViewController: UITableViewController, UISearchBarDelegate {
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        self.navigationItem.titleView = searchBar
        
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            SearchManager.shared.search(for: Music.self, with: searchText, for: self.tableView)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        SearchManager.shared.results.removeAll()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchManager.shared.results.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        // Retrieve the song object from the SearchManager shared instance's results array
        let song = SearchManager.shared.results[indexPath.row]
        
        // Set the cell's title label text to the song's title
        cell.textLabel?.text = song.trackName
        return cell
        
    }
    
    
}

