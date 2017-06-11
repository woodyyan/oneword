//
//  AboutViewControler.swift
//  OneWord
//
//  Created by Songbai Yan on 10/06/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "关于"
        self.view.backgroundColor = UIColor.white
        
        initUI()
    }
    
    private func initUI(){
        let iconView = UIImageView(image: UIImage(named: "logo"))
        self.view.addSubview(iconView)
        iconView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.view.snp.centerX)
            maker.top.equalTo(self.view).offset(120)
        }
        
        let sloganLabel = UILabel()
        sloganLabel.text = "玩着手机记单词"
        sloganLabel.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 66/255)
        self.view.addSubview(sloganLabel)
        sloganLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconView.snp.bottom).offset(20)
            maker.centerX.equalTo(self.view)
        }
        
        let versionLabel = UILabel()
        versionLabel.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 66/255)
        versionLabel.text = "版本号：V\(getCurrentVersion())"
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.view).offset(-90)
            maker.centerX.equalTo(self.view)
        }
        
        initBottomView()
    }
    
    private func getCurrentVersion(_ bundleVersion:Bool = false) -> String{
        guard let infoDic = Bundle.main.infoDictionary else {return ""}
        guard let currentVersion = infoDic["CFBundleShortVersionString"] as? String else {return ""}
        if let buildVersion = infoDic["CFBundleVersion"] as? String , bundleVersion == true {
            return currentVersion + buildVersion
        }else {
            return currentVersion
        }
    }
    
    private func initBottomView(){
        let bottomView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 70, width: self.view.frame.width, height: 70))
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.view)
            maker.width.equalTo(self.view)
            maker.height.equalTo(70)
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1))
        lineView.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        bottomView.addSubview(lineView)
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(bottomView)
            maker.width.equalTo(bottomView)
            maker.height.equalTo(1)
        }
        
        let feedbackButton = UIButton(type: UIButtonType.system)
        feedbackButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        feedbackButton.setTitle("反馈", for: UIControlState())
        feedbackButton.addTarget(self, action: #selector(AboutViewController.feedbackClick(sender:)), for: .touchUpInside)
        
        //微博按钮
        let weiboButton = UIButton(type: UIButtonType.system)
        weiboButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        weiboButton.setTitle("微博", for: UIControlState())
        weiboButton.addTarget(self, action: #selector(AboutViewController.weiboClick(sender:)), for: UIControlEvents.touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [feedbackButton, weiboButton])
        stackView.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: 30)
        stackView.distribution = .fillEqually
        bottomView.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(bottomView).offset(10)
            maker.width.equalTo(bottomView)
            maker.height.equalTo(30)
        }
        
        let companyLabel = UILabel(frame: CGRect(x: 0, y: 40, width: self.view.frame.width, height: 15))
        companyLabel.text = "Powered by 略懂工作室"
        companyLabel.textColor = UIColor.gray
        companyLabel.font = UIFont.systemFont(ofSize: 10)
        companyLabel.textAlignment = NSTextAlignment.center
        bottomView.addSubview(companyLabel)
        companyLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(stackView.snp.bottom).offset(5)
            maker.width.equalTo(bottomView)
            maker.height.equalTo(15)
        }
    }
    
    func feedbackClick(sender:UIButton) {
        
    }
    
    func weiboClick(sender:UIButton){
        if let url = URL(string: "http://weibo.com/u/5613355795") {
            UIApplication.shared.open(url, options: [String : Any](), completionHandler: nil)
        }
    }
}
