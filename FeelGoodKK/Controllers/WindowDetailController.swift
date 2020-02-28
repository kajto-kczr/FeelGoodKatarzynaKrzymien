//
//  WindowDetailController.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 17.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit


final class WindowDetailController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let uiColors: [UIColor] = [UIColor(red: 83/255, green: 119/255, blue: 166/255, alpha: 0.65),
                               UIColor(red: 2/255, green: 72/255, blue: 115/255, alpha: 0.45),
                               UIColor(red: 2/255, green: 89/255, blue: 89/255, alpha: 0.35),
    UIColor(red: 2/255, green: 115/255, blue: 104/255, alpha: 0.45),
    UIColor(red: 13/255, green: 13/255, blue: 13/255, alpha: 0.05)]
    static let identifier = String(describing: WindowDetailController.self)
    private let window: Window
    @IBOutlet weak var windowCoverImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var caloriesImageView: UIImageView!
    @IBOutlet weak var caloriesLabel: UILabel!
    var favoritesDict = DataSource.shared.favoritesDict
    let dataSource = DataSource.shared
    
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
    
//    @objc func navBarItemTapped() {
//        self.dismiss(animated: false, completion: nil)
//    }
    
    private func setupView() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        self.title = window.title
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: screenWidth * 0.45, height: screenWidth / 5)
        layout.itemSize = CGSize(width: screenWidth, height: screenSize.height / 5)
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        windowCoverImageView.image = window.image
        windowCoverImageView.backgroundColor = window.imageBackgroundColor
        timeLabel.text = window.timeNeeded
        caloriesLabel.text = window.calories
        
        if favoritesDict[window.id] == true {
            addToFavoriteButton.setTitle("Is Favorite", for: UIControl.State())
        } else {
            addToFavoriteButton.setTitle("Make Favorite", for: UIControl.State())
        }
        
    }
    
    @IBAction func addToFavoritesTapped(_ sender: Any) {
        
        if favoritesDict[window.id] == true {
            print("unlike Exercise")
            favoritesDict[window.id] = false
            dataSource.saveInUserDefaults(json: favoritesDict)
            dataSource.getFavorites()
            addToFavoriteButton.setTitle("Make Favorite", for: UIControl.State())
        } else {
            print("like Exercise")
            favoritesDict[window.id] = true
            dataSource.saveInUserDefaults(json: favoritesDict)
            dataSource.getFavorites()
            addToFavoriteButton.setTitle("Is Favorite", for: UIControl.State())
        }
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
        let gradientColors = [window.imageBackgroundColor?.cgColor, UIColor.black.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = cell.elementContentView.frame.size
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        cell.elementContentView.layer.insertSublayer(gradientLayer, at: 0)
        cell.layer.cornerRadius = 10
        cell.elementTitleLabel.numberOfLines = 0
        cell.elementTitleLabel.lineBreakMode = .byWordWrapping
        cell.elementTitleLabel.text = "\(indexPath.row + 1). " + window.content[indexPath.row].title
        cell.elementTitleLabel.textColor = UIColor.white
        cell.elementImageView.image = window.content[indexPath.row].image
        cell.elementImageView.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = window.content[indexPath.row]
        let elementViewController = storyboard?.instantiateViewController(identifier: ElementViewController.identifier, creator: { coder in
            return ElementViewController(coder: coder, element: section.content)
        })
        elementViewController?.modalPresentationStyle = .fullScreen
        UserDefaults.standard.set(window.content[indexPath.row].title, forKey: "title")
        self.navigationController?.pushViewController(elementViewController!, animated: true)
    }
}
