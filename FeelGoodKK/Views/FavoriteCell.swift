//
//  FavoriteCell.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 21.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: FavoriteCell.self)
    
    @IBOutlet weak var favoriteTitleLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteContentView: UIView!
    
    
}
