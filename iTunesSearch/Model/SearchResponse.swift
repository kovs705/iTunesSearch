//
//  SearchResponse.swift
//  iTunesSearch
//
//  Created by Kovs on 01.05.2023.
//

import Foundation

struct SearchResponse: Decodable {
    let results: [SearchResult]
}

/// for non explicit results filter everything before showing to user any content:
extension SearchResponse {
    var nonExplicitResults: [SearchResult] {
        return self.results.filter { (result) in
            result.trackExplicitness != .explicit
        }
    }
}
