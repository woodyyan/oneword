//
//  WordView.swift
//  OneWord
//
//  Created by Songbai Yan on 06/06/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit

class WordView: UIView {
    var wordLabel:UILabel!
    var soundmarkLabel:UILabel!
    var partOfSpeechLabel:UILabel!
    var paraphraseLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        wordLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 40))
        wordLabel.textColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
        wordLabel.font = UIFont.systemFont(ofSize: 24)
//        wordLabel.text = word.text;
        self.addSubview(wordLabel)
        wordLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(78)
            maker.width.equalTo(self).offset(-156)
            maker.top.equalTo(self).offset(120)
        }
        
        soundmarkLabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.frame.width, height: 40))
//        soundmarkLabel.text = word.soundmark
        soundmarkLabel.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        self.addSubview(soundmarkLabel)
        soundmarkLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(78)
            maker.width.equalTo(self).offset(-156)
            maker.top.equalTo(wordLabel.snp.bottom).offset(20)
        }
        
        partOfSpeechLabel = UILabel()
        partOfSpeechLabel.textColor = UIColor.white
        partOfSpeechLabel.textAlignment = .center
        partOfSpeechLabel.layer.cornerRadius = 5
        partOfSpeechLabel.layer.backgroundColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1).cgColor
//        partOfSpeechLabel.text = word.partOfSpeech
        partOfSpeechLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(partOfSpeechLabel)
        partOfSpeechLabel.snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(25)
            maker.height.equalTo(25)
            maker.left.equalTo(self).offset(78)
            maker.top.equalTo(soundmarkLabel.snp.bottom).offset(20)
        }
        
        paraphraseLabel = UILabel(frame: CGRect(x: 0, y: 200, width: self.frame.width, height: 40))
//        paraphraseLabel.text = word.paraphrase
        paraphraseLabel.font = UIFont.systemFont(ofSize: 17)
        paraphraseLabel.numberOfLines = 0
        paraphraseLabel.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        self.addSubview(paraphraseLabel)
        paraphraseLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(partOfSpeechLabel.snp.right).offset(10)
            maker.width.equalTo(self).offset(-156)
            maker.centerY.equalTo(partOfSpeechLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
