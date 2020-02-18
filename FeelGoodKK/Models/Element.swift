//
//  Element.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 18.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import Foundation

struct Element: Decodable {
    let url: String
    let description: String
}

extension Element: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

extension Element: Equatable {
    static func ==(lhs: Element, rhs: Element) -> Bool {
        return lhs.url == rhs.url
    }
}
