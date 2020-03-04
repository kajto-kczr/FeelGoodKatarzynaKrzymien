//
//  LibraryViewController.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 17.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit

final class LibraryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<LibraryCollection, Window>!
    private let libraryCollections = DataSource.shared.collections
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupView() {
        collectionView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 0.95)
        self.title = "Feel Good Training"
        collectionView.delegate = self
        collectionView.register(TitleSuplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSuplementaryView.reuseIdentifier)
        collectionView.collectionViewLayout = configureCollectionViewLayout()
        configureDataSource()
        configureSnapshot()
    }
}

// MARK: - Collection View -
extension LibraryViewController {
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.3))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.interGroupSpacing = 10
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(0.4))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.interGroupSpacing = 10
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            }
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}

// MARK: - Diffable Data Source -
extension LibraryViewController {
    typealias LibraryDataSource = UICollectionViewDiffableDataSource<LibraryCollection, Window>
    func configureDataSource() {
        dataSource = LibraryDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, window: Window) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WindowCell.reuseIdentifier, for: indexPath) as? WindowCell else {
                return nil
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
            
            cell.titleLabel.text = window.title
            cell.titleLabel.numberOfLines = 0
            cell.titleLabel.lineBreakMode = .byWordWrapping
            cell.thumbnailImageView.image = window.image
            cell.layer.cornerRadius = 10
//            cell.thumbnailImageView.layer.masksToBounds = true
            cell.thumbnailImageView.backgroundColor = window.imageBackgroundColor
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            if let self = self, let titleSuplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSuplementaryView.reuseIdentifier, for: indexPath) as? TitleSuplementaryView {
                
                let libraryCollection = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                titleSuplementaryView.textLabel.text = libraryCollection.title
                titleSuplementaryView.textLabel.textColor = UIColor(red: 2/255, green: 115/255, blue: 104/255, alpha: 0.85)
                
                return titleSuplementaryView
            } else {
                return nil
            }
        }
    }
    
    func configureSnapshot() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<LibraryCollection, Window>()
        
        libraryCollections.forEach { collection in
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.windows)
        }
        
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate -
extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.first != 2 else {
            switch indexPath.row {
            case 0:
                let progressViewController = storyboard?.instantiateViewController(withIdentifier: ProgressViewController.identifier)
                show(progressViewController!, sender: nil)
            case 1:
                print("Setting Tapped")
            default:
                break
            }
            return
        }
        
        if let window = dataSource.itemIdentifier(for: indexPath),
            let windowDetailController = storyboard?.instantiateViewController(identifier: WindowDetailController.identifier, creator: { coder in
                return WindowDetailController(coder: coder, window: window)
            }) {
            show(windowDetailController, sender: nil)
        }
    }
}
