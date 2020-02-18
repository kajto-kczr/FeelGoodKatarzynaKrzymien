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
    @IBOutlet weak var descriptionLabel: UILabel!
    private let element: [Element]
    
    required init?(coder: NSCoder) {
        fatalError("inint(coder:) has not been implemented")
    }
    
    init?(coder: NSCoder, element: [Element]) {
        self.element = element
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = element[0].description
        loadYoutube(videoID: element[0].url)
    }
    
    func loadYoutube(videoID: String) {
        guard let youtubeURL = URL(string: videoID) else {
            return
        }
        videoView.load(URLRequest(url: youtubeURL))
    }
}
