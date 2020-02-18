//
//  Section.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 17.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit

struct Section: Decodable, Hashable {
    let title: String
    let picture: String
    let content: [Element]
    let identifier = UUID().uuidString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Section, rhs: Section) -> Bool {
        return lhs.title == rhs.title
    }
}

extension Section {
    var image: UIImage? {
        return UIImage(named: picture)
    }
}
