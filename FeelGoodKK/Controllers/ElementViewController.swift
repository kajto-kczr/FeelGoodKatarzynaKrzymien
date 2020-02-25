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
    @IBOutlet weak var doneItButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    
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
        
        setupViews()
        let titleString = UserDefaults.standard.string(forKey: "title") ?? "Defaults Not Working"
        navBarTitle.title = titleString
        
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        print("Done Tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        self.view.bringSubviewToFront(doneItButton)
        
        self.scrollView.contentSize = CGSize(width: screenWidth, height: screenSize.height * 0.7)
        
        
        let lbl1 = UILabel(frame: CGRect(x: 10, y: 8, width: screenWidth * 0.9, height: 20))
        lbl1.text = element[0].info
        lbl1.myLabel()
        scrollView.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect(x: 10, y: lbl1.frame.maxY + 25, width: screenWidth * 0.9, height: 20))
        lbl2.text = "Description: \n\n" + element[0].description
        lbl2.myLabel()
        scrollView.addSubview(lbl2)
        
        

        let lbl3 = UILabel(frame: CGRect(x: 10, y: lbl2.frame.maxY + 25, width: screenWidth * 0.9, height: 20))
//        let lbl3 = UILabel()
        lbl3.text = "Repeat: \n\n" + element[0].repetition
        print(scrollView.frame.midX)
        print(lbl3.frame.midX)
        lbl3.myLabel()
        scrollView.addSubview(lbl3)

        let lbl4 = UILabel(frame: CGRect(x: 10, y: lbl3.frame.maxY + 25, width: screenWidth * 0.9, height: 20))
//        let lbl4 = UILabel()
        lbl4.text = "Purpose: \n\n" + element[0].point
        lbl4.myLabel()
        scrollView.addSubview(lbl4)
        
        scrollView.sizeToFit()
        
        lbl1.center.x = self.view.center.x
        lbl2.center.x = self.view.center.x
        lbl3.center.x = self.view.center.x
        lbl4.center.x = self.view.center.x
        
        
    }
    
    func loadYoutube(videoID: String) {
        guard let youtubeURL = URL(string: videoID) else {
            return
        }
        videoView.load(URLRequest(url: youtubeURL))
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UILabel {
    func myLabel() {
        textAlignment = .center
        textColor = .red
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        layer.masksToBounds = true
        font = UIFont.systemFont(ofSize: 17)
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        sizeToFit()
//        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        
        
    }
}
