//
//  DataSource.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 17.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import Foundation

class DataSource {
    
    static let shared = DataSource()
    var collections: [LibraryCollection]
    var favorites: [Window] = []
    private let decoder = PropertyListDecoder()
    
    private init() {
        guard let url = Bundle.main.url(forResource: "Collection", withExtension: "plist"),
        let data = try? Data(contentsOf: url),
            let collections = try? decoder.decode([LibraryCollection].self, from: data) else {
                self.collections = []
                return
        }
        
        self.collections = collections
        getFavorites()
    }
}

extension DataSource {
    func getFavorites() {
        for collection in collections {
            for window in collection.windows {
                if window.isFavorite == true {
                    favorites.append(window)
                }
            }
        }
    }
}
