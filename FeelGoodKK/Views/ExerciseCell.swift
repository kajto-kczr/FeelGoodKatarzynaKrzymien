//
//  ExerciseCell.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 02.03.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit

class ExerciseCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: ExerciseCell.self)
    
    @IBOutlet weak var exerciseContentView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}
