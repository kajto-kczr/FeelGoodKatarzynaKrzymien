//
//  FavoritesViewController.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 21.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private let favoritesCollections = DataSource.shared.favorites
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Window, Section>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Favorites"
        setupView()
    }
    
    private func setupView() {
       let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width / 4)
        favoritesCollectionView.collectionViewLayout = layout
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as? FavoriteCell else {
            fatalError("Error Cell")
        }
        
        cell.favoriteTitleLabel.text = favoritesCollections[indexPath.row].title
        cell.favoriteImageView.image = favoritesCollections[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
