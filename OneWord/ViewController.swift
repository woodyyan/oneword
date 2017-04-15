//
//  ViewController.swift
//  OneWord
//
//  Created by Songbai Yan on 15/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let word1 = Word(text: "abandon", soundmark: "[ə'bændən]", paraphrase: "vt. 丢弃，放弃，抛弃")
        
        let wordLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        wordLabel.textAlignment = .center
        wordLabel.text = word1.text;
        self.view.addSubview(wordLabel)
        wordLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.view.snp.centerX)
            maker.width.equalTo(self.view)
            maker.top.equalTo(self.view).offset(60)
        }
        
        let soundmarkLabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 40))
        soundmarkLabel.text = word1.soundmark
        soundmarkLabel.textAlignment = .center
        self.view.addSubview(soundmarkLabel)
        soundmarkLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.view.snp.centerX)
            maker.width.equalTo(self.view)
            maker.top.equalTo(wordLabel.snp.bottom).offset(20)
        }
        
        let paraphraseLabel = UILabel(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 40))
        paraphraseLabel.text = word1.paraphrase
        paraphraseLabel.textAlignment = .center
        self.view.addSubview(paraphraseLabel)
        paraphraseLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.view.snp.centerX)
            maker.width.equalTo(self.view)
            maker.top.equalTo(soundmarkLabel.snp.bottom).offset(20)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

