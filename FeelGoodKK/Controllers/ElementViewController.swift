//
//  ElementViewController.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 18.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit
import WebKit

class ElementViewController: UIViewController {
    
    static let identifier = String(describing: ElementViewController.self)
    @IBOutlet weak var videoView: WKWebView!
    private let element: [Element]
    var progressArray: [String] = []
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var exerciseCollectionView: UICollectionView!
    
    
    required init?(coder: NSCoder) {
        fatalError("inint(coder:) has not been implemented")
    }
    
    init?(coder: NSCoder, element: [Element]) {
        self.element = element
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadYoutube(videoID: element[0].url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleString = UserDefaults.standard.string(forKey: "title") ?? "Feel Good"
        title = titleString
        let arr = UserDefaults.standard.array(forKey: "progressArray")
        if arr != nil {
            progressArray = arr as! [String]
        }
        
        
        let barButton = UIBarButtonItem(title: "Done it!", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem = barButton
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([videoView.heightAnchor.constraint(equalToConstant: 400)])
        } else {
            NSLayoutConstraint.activate([videoView.heightAnchor.constraint(equalToConstant: 200)])
        }
        
        exerciseCollectionView.dataSource = self
        exerciseCollectionView.collectionViewLayout = configureCollectionViewLayout()
    }
    
    @objc func doneTapped() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        let stringForArray = "\(dateString);\(String(title!))"
        progressArray.append(stringForArray)
        UserDefaults.standard.set(progressArray, forKey: "progressArray")
        let alert = UIAlertController(title: "Well done!", message: "Exercise added to your progress history.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(1.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.45))
                let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
                trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
                
                let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize, subitem: trailingItem, count: 2)
                let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.5), heightDimension: .fractionalHeight(1.0))
                let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [group, trailingGroup])
                
                let section = NSCollectionLayoutSection(group: containerGroup)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                section.interGroupSpacing = 10
                
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.75))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
                let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
                let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
                trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
                
                let trailingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: trailingGroupSize, subitem: trailingItem, count: 2)
                let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(2.2))
                let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: containerGroupSize, subitems: [group, trailingGroup])
                
                let section = NSCollectionLayoutSection(group: containerGroup)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                section.interGroupSpacing = 10
                
                return section
            }
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    func loadYoutube(videoID: String) {
        guard let youtubeURL = URL(string: videoID) else {
            return
        }
        videoView.load(URLRequest(url: youtubeURL))
    }
}

extension ElementViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCell.reuseIdentifier, for: indexPath) as? ExerciseCell else {
            fatalError("Couldn‘t create exercise cell")
        }
        let arrDescriptions = [element[0].info, element[0].description, element[0].repetition, element[0].point]
        let arrTitle = ["Info", "Description", "Repeat", "Purpose"]
        
        cell.contentView.backgroundColor = UIColor(red: 8/255, green: 74/255, blue: 89/255, alpha: 1)
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
        cell.titleLabel.textColor = UIColor(red: 191/255, green: 214/255, blue: 217/255, alpha: 0.85)
        cell.descriptionLabel.text = arrDescriptions[indexPath.row]
        cell.titleLabel.text = arrTitle[indexPath.row]
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            cell.descriptionLabel.font = UIFont(name: "System", size: 14)
        }
        
        return cell
    }
}
