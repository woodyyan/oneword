//
//  GuideViewController.swift
//  OneWord
//
//  Created by Songbai Yan on 12/06/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "通知中心指南"
        self.view.backgroundColor = UIColor.white
        
        initUI()
    }
    
    private func initUI(){
        let imageView = UIImageView(image: UIImage(named: "guideImage"))
        
        let scrollView = UIScrollView(frame: self.view.frame)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: imageView.frame.height)
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
}
