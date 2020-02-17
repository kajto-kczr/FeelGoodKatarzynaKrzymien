//
//  Window.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 17.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit

class Window: Decodable, Hashable {
    let title: String
    let thumbnail: String
    let artworkColor: String
    let content: [Section]
    let identifier = UUID().uuidString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Window, rhs: Window) -> Bool {
        return lhs.title == rhs.title
    }
}

extension Window {
    var image: UIImage? {
        return UIImage(named: thumbnail)
    }
    
    var imageBackgroundColor: UIColor? {
        return UIColor(hexString: artworkColor)
    }
}
