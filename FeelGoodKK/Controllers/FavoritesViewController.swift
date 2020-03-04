//
//  FavoritesViewController.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 21.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
//    private let favoritesCollections = DataSource.shared.favorites
    private var favoritesCollections: [Window] = []
    private var dict = DataSource.shared.favoritesDict
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Window, Section>!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Favorites"
        DataSource.shared.getFavorites()
        favoritesCollections = DataSource.shared.favorites.removeDuplicates()
        setupView()
        
    }
    
    
    private func setupView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width / 5)
        favoritesCollectionView.collectionViewLayout = layout
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        if #available(iOS 10.0, *) {
            favoritesCollectionView.refreshControl = refreshControl
        } else {
            favoritesCollectionView.addSubview(refreshControl)
        }
        
        let color = UIColor(red: 83/255, green: 119/255, blue: 166/255, alpha: 0.65)
        refreshControl.tintColor = color
        let attributedStringColor = [NSAttributedString.Key.foregroundColor: color]
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Favorites...", attributes: attributedStringColor)
        refreshControl.addTarget(self, action: #selector(refreshFavorites), for: .valueChanged)
    }

    @objc func refreshFavorites() {
        DataSource.shared.getFavorites()
        favoritesCollections = DataSource.shared.favorites.removeDuplicates()
        favoritesCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as? FavoriteCell else {
            fatalError("Error Cell")
        }
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
        
        
        cell.favoriteTitleLabel.text = favoritesCollections[indexPath.row].title
        cell.favoriteImageView.image = favoritesCollections[indexPath.row].image
        cell.favoriteImageView.backgroundColor = favoritesCollections[indexPath.row].imageBackgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let wvc = storyboard?.instantiateViewController(identifier: WindowDetailController.identifier, creator: { coder in
            return WindowDetailController(coder: coder, window: self.favoritesCollections[indexPath.row])
        })
        show(wvc!, sender: nil)
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
