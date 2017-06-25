//
//  TodayViewController.swift
//  OneWordTodayExtenstion
//
//  Created by Songbai Yan on 25/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit
import NotificationCenter
import SnapKit

class TodayViewController: UIViewController, NCWidgetProviding {
    let service = MainService()
    
    var wordLabel:UILabel!
    var soundmarkLabel:UILabel!
    var partOfSpeechLabel:UILabel!
    var paraphraseLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        let word = service.getRandomWord()
        initWordUI(word: word)
        initSwitchButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.extensionContext?.open(URL(string: "EasyStudioOneWord://action=OpenHomePage")!, completionHandler: nil)
    }
    
    private func initSwitchButton(){
        let switchButton = UIButton(type: .system)
        switchButton.setTitle("switch", for: .normal)
        switchButton.addTarget(self, action: #selector(TodayViewController.switchClick(sender:)), for: .touchUpInside)
        self.view.addSubview(switchButton)
        switchButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(8)
            maker.right.equalTo(self.view).offset(-8)
        }
    }
    
    func switchClick(sender:UIButton){
        let word = service.getRandomWord()
        wordLabel.text = word.text
        soundmarkLabel.text = word.soundmark
        partOfSpeechLabel.text = word.partOfSpeech
        paraphraseLabel.text = word.paraphrase
    }
    
    private func initWordUI(word:Word){
        wordLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        wordLabel.textColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
        wordLabel.font = UIFont.systemFont(ofSize: 24)
        wordLabel.text = word.text;
        self.view.addSubview(wordLabel)
        wordLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(36)
            maker.width.equalTo(self.view).offset(-72)
            maker.top.equalTo(self.view).offset(8)
        }
        
        soundmarkLabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 40))
        soundmarkLabel.text = word.soundmark
        soundmarkLabel.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        self.view.addSubview(soundmarkLabel)
        soundmarkLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(36)
            maker.width.equalTo(self.view).offset(-72)
            maker.top.equalTo(wordLabel.snp.bottom).offset(8)
        }
        
        partOfSpeechLabel = UILabel()
        partOfSpeechLabel.textColor = UIColor.white
        partOfSpeechLabel.textAlignment = .center
        partOfSpeechLabel.layer.cornerRadius = 5
        partOfSpeechLabel.layer.backgroundColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1).cgColor
        partOfSpeechLabel.text = word.partOfSpeech
        partOfSpeechLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(partOfSpeechLabel)
        partOfSpeechLabel.snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(25)
            maker.height.equalTo(25)
            maker.left.equalTo(self.view).offset(36)
            maker.top.equalTo(soundmarkLabel.snp.bottom).offset(10)
        }
        
        paraphraseLabel = UILabel(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 40))
        paraphraseLabel.text = word.paraphrase
        paraphraseLabel.font = UIFont.systemFont(ofSize: 17)
        paraphraseLabel.numberOfLines = 0
        paraphraseLabel.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        self.view.addSubview(paraphraseLabel)
        paraphraseLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(partOfSpeechLabel.snp.right).offset(10)
            maker.width.equalTo(self.view).offset(-72)
            maker.centerY.equalTo(partOfSpeechLabel)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}
