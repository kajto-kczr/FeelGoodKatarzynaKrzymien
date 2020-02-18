//
//  ElementCell.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 18.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit

class ElementCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ElementCell.self)
    
    @IBOutlet weak var elementTitleLabel: UILabel!
    @IBOutlet weak var elementImageView: UIImageView!
    @IBOutlet weak var elementContentView: UIView!
    
    
}
