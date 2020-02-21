//
//  ScrollViewController.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 20.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView(image: UIImage(named: "picture"))
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = .black
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        scrollView.contentOffset = CGPoint(x: 1000, y: 450)
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
    }
}
