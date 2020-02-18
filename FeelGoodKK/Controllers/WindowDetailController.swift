//
//  WindowDetailController.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 17.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit

final class WindowDetailController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    static let identifier = String(describing: WindowDetailController.self)
    private let window: Window
    @IBOutlet weak var windowCoverImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var caloriesImageView: UIImageView!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    
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
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //        let screenHeight = screenSize.height
        
        self.title = window.title
        //        collectionView.collectionViewLayout = configureCollectionViewLayout()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth * 0.9, height: screenWidth / 3)
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        windowCoverImageView.image = window.image
        windowCoverImageView.backgroundColor = window.imageBackgroundColor
        //        guard window.timeNeeded != "0" else {
        //            timeLabel.isHidden = true
        //            timeImageView.isHidden = true
        //            caloriesLabel.isHidden = true
        //            caloriesImageView.isHidden = true
        //            addToFavoriteButton.isHidden = true
        //            return
        //        }
        timeLabel.text = window.timeNeeded
        caloriesLabel.text = window.calories
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return window.content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ElementCell.reuseIdentifier, for: indexPath) as? ElementCell else {
            fatalError("ERROR CELL")
        }
        let gradientColors = [UIColor(red: 46/255, green: 99/255, blue: 255/255, alpha: 0.8).cgColor, UIColor(red: 203/255, green: 38/255, blue: 255/255, alpha: 0.8).cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = cell.elementContentView.frame.size
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        cell.elementContentView.layer.insertSublayer(gradientLayer, at: 0)
        //        cell.elementContentView.layer.addSublayer(gradientLayer)
        cell.layer.cornerRadius = 10
        cell.elementTitleLabel.text = window.content[indexPath.row].title
        cell.elementImageView.image = window.content[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = window.content[indexPath.row]
        print(section.content)
        let elementViewController = storyboard?.instantiateViewController(identifier: ElementViewController.identifier, creator: { coder in
            return ElementViewController(coder: coder, element: section.content)
        })
        present(elementViewController!, animated: true)
    }
}
