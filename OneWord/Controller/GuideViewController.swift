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
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: imageView.frame.height)
        
        let scrollView = UIScrollView(frame: self.view.frame)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: imageView.frame.height)
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        let okButton = UIButton(type: .system)
        okButton.setTitle("Got it", for: .normal)
        okButton.setTitleColor(UIColor.darkGray, for: .normal)
        okButton.backgroundColor = UIColor.white
        okButton.layer.cornerRadius = 5
        okButton.addTarget(self, action: #selector(GuideViewController.okClick(sender:)), for: .touchUpInside)
        scrollView.addSubview(okButton)
        okButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(scrollView)
            maker.width.equalTo(80)
            maker.height.equalTo(30)
            maker.bottom.equalTo(imageView).offset(-20)
        }
    }
    
    @objc func okClick(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
