//
//  LibraryCollection.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 17.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import Foundation

struct LibraryCollection: Decodable, Hashable {
    let title: String
    let windows: [Window]
    let identifier = UUID().uuidString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: LibraryCollection, rhs: LibraryCollection) -> Bool {
        return lhs.title == rhs.title
    }
}
