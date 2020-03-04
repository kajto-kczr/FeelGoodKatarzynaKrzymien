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
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([windowCoverImageView.heightAnchor.constraint(equalToConstant: 320)])
        } else {
            NSLayoutConstraint.activate([windowCoverImageView.heightAnchor.constraint(equalToConstant: 200)])
        }
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
////        layout.itemSize = CGSize(width: screenWidth * 0.45, height: screenWidth / 5)
//        layout.itemSize = CGSize(width: screenWidth, height: screenSize.height / 5)
//        collectionView.collectionViewLayout = layout
        collectionView.collectionViewLayout = configureCollectionViewLayout()
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
    
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4)
            
            var groupSize: NSCollectionLayoutSize!
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35), heightDimension: .fractionalHeight(1.0))
            } else {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            }
            
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.interGroupSpacing = 10
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
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
        
        cell.contentView.backgroundColor = window.imageBackgroundColor
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor(red: 109/255, green: 155/255, blue: 166/255, alpha: 0.65).cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor(red: 25/255, green: 98/255, blue: 115/255, alpha: 0.45).cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 10)
        cell.layer.shadowOpacity = 0.7
        cell.layer.shadowRadius = 5
        cell.layer.masksToBounds = false
        cell.clipsToBounds = false
        cell.elementTitleLabel.numberOfLines = 0
        cell.elementTitleLabel.lineBreakMode = .byWordWrapping
        cell.elementTitleLabel.text = "\(indexPath.row + 1). \n" + window.content[indexPath.row].title
        cell.elementTitleLabel.textColor = UIColor.white
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
