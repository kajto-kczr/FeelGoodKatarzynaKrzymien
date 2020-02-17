//
//  WindowDetailController.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 17.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit

class WindowDetailController: UIViewController {
    
    static let identifier = String(describing: WindowDetailController.self)
    private let window: Window
    @IBOutlet weak var windowCoverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init?(coder: NSCoder, window: Window) {
        self.window = window
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.title = window.title
        windowCoverImageView.image = window.image
        windowCoverImageView.backgroundColor = window.imageBackgroundColor
        titleLabel.text = window.title
        
    }
}
