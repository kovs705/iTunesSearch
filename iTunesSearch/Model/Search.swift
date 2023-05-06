//
//  Search.swift
//  iTunesSearch
//
//  Created by Kovs on 05.05.2023.
//

import Foundation
import CoreMedia
import UIKit
import AppleiTunesSearchURLComponents

class SearchManager {
    
    static let shared = SearchManager()
    
    var dataTask: URLSessionDataTask? = nil
    var results: [SearchResult] = [] // a result returned from iTunes API
    
    
    func search<T>(for type: T.Type, with term: String, for tableView: UITableView) where T: MediaType {
        // translate typeand term into HTTP request
        /// for iTunes Search API all parameters are encoded into the URL query of a GET request:
        let components = AppleiTunesSearchURLComponents<T>(term: term)
        
        guard let url = components.url else {
            fatalError("Error creating URL")
        }
        
        decodeTheReceivedData(from: url, in: tableView)
        
    }
    
    func decodeTheReceivedData(from url: URL, in tableView: UITableView) {
        /// cancel existing dataTask if one pending:
        self.dataTask?.cancel()
        
        self.dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                fatalError("Networking error \(String(describing: error)), \(String(describing: response))")
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                
                self.results = searchResponse.nonExplicitResults
            } catch {
                fatalError("Decoding error \(error)")
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateUI(for: tableView)
            }
        }
        
        self.dataTask?.resume()
    }
    
    func updateUI(for tableView: UITableView) {
        tableView.reloadData()
    }
}
