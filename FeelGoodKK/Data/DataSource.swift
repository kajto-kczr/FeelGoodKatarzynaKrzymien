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
    var favoritesDict: [Int:Bool] = [:]
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
        saveInUserDefaults(json: favoritesDict)
        print("From DS, Favorites: \(favorites)")
        print("And dict: \(favoritesDict)")
        print("Count: \(favorites.count)")
    }
}

extension DataSource {
    func saveInUserDefaults(json: [Int:Bool]) {
        let myData = NSKeyedArchiver.archivedData(withRootObject: json)
        UserDefaults.standard.set(myData, forKey: "UserSession")
    }
    
    func getUserDefaults() -> [Int:Bool]? {
        if let user = UserDefaults.standard.object(forKey: "UserSession") as? Data {
            let recoveredJson = NSKeyedUnarchiver.unarchiveObject(with: user) as! [Int:Bool]
            return recoveredJson
        } else {
            return nil
        }
    }
    
    func getFavorites() {
        if getUserDefaults() != nil {
            favoritesDict = getUserDefaults()!
        } else {
            for collection in collections {
                for window in collection.windows {
                    favoritesDict[window.id] = false
                }
            }
        }
        
        for collection in collections {
            for window in collection.windows {
                if favoritesDict[window.id] == true {
                    favorites.append(window)
                }
            }
        }
    }
}
