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
    @IBOutlet weak var scrollView: UIScrollView!
    var progressArray: [String] = []
    @IBOutlet weak var backgroundView: UIView!
    
    
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
        
        backgroundView.backgroundColor = UIColor(red: 2/255, green: 72/255, blue: 115/255, alpha: 0.45)
        
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
    
    
    private func setupViews() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        self.scrollView.contentSize = CGSize(width: screenWidth - 48, height: screenSize.height * 0.7)
        
        
        let lbl1 = UILabel(frame: CGRect(x: 10, y: 8, width: screenWidth * 0.9, height: 20))
        lbl1.text = element[0].info
        lbl1.myLabel()
        scrollView.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect(x: 10, y: lbl1.frame.maxY + 25, width: screenWidth * 0.9, height: 20))
        lbl2.text = "Description: \n\n" + element[0].description
        lbl2.myLabel()
        scrollView.addSubview(lbl2)
        
        
        
        let lbl3 = UILabel(frame: CGRect(x: 10, y: lbl2.frame.maxY + 25, width: screenWidth * 0.9, height: 20))
        lbl3.text = "Repeat: \n\n" + element[0].repetition
        print(scrollView.frame.midX)
        print(lbl3.frame.midX)
        lbl3.myLabel()
        scrollView.addSubview(lbl3)
        
        let lbl4 = UILabel(frame: CGRect(x: 10, y: lbl3.frame.maxY + 25, width: screenWidth * 0.9, height: 20))
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
        textColor = .white
        backgroundColor = UIColor(red: 83/255, green: 119/255, blue: 166/255, alpha: 0.65)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        font = UIFont.systemFont(ofSize: 17)
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        sizeToFit()
    }
}
