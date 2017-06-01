//
//  ViewController.swift
//  OneWord
//
//  Created by Songbai Yan on 15/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "随记单词"
        self.view.backgroundColor = UIColor.white
        
        let word = Word(text: "abandon", soundmark: "[ə'bændən]", partOfSpeech: "vt.", paraphrase: "丢弃，放弃，抛弃")
        initWordUI(word: word)
        initWriteBoardView()
        
        do {
            if let path = Bundle.main.path(forResource: "words", ofType: "txt") {
                let data = try String(contentsOfFile: path)
                let myStrings = data.components(separatedBy: .newlines)
                print(myStrings.count)
            }
        } catch let error{
            print(error)
        }
    }
    
    private func initWriteBoardView(){
        let boardView = UIView()
        boardView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        boardView.layer.shadowColor = UIColor.red.cgColor//UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        boardView.layer.masksToBounds = false
//        boardView.layer.shadowOffset = CGSize(width: 500, height: 300)
        boardView.layer.shadowRadius = 5
        self.view.addSubview(boardView)
        boardView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.height.equalTo(250)
        }
    }
    
    private func initWordUI(word:Word){
        let wordLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        wordLabel.textColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
        wordLabel.font = UIFont.systemFont(ofSize: 24)
        wordLabel.text = word.text;
        self.view.addSubview(wordLabel)
        wordLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(78)
            maker.width.equalTo(self.view).offset(-156)
            maker.top.equalTo(self.view).offset(120)
        }
        
        let soundmarkLabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 40))
        soundmarkLabel.text = word.soundmark
        soundmarkLabel.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        self.view.addSubview(soundmarkLabel)
        soundmarkLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(78)
            maker.width.equalTo(self.view).offset(-156)
            maker.top.equalTo(wordLabel.snp.bottom).offset(20)
        }
        
        let partOfSpeechLabel = UILabel()
        partOfSpeechLabel.textColor = UIColor.white
        partOfSpeechLabel.textAlignment = .center
        partOfSpeechLabel.layer.cornerRadius = 5
        partOfSpeechLabel.layer.backgroundColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1).cgColor
        partOfSpeechLabel.text = word.partOfSpeech
        partOfSpeechLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(partOfSpeechLabel)
        partOfSpeechLabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(25)
            maker.height.equalTo(25)
            maker.left.equalTo(self.view).offset(78)
            maker.top.equalTo(soundmarkLabel.snp.bottom).offset(20)
        }
        
        let paraphraseLabel = UILabel(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 40))
        paraphraseLabel.text = word.paraphrase
        paraphraseLabel.font = UIFont.systemFont(ofSize: 17)
        paraphraseLabel.numberOfLines = 0
        paraphraseLabel.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        self.view.addSubview(paraphraseLabel)
        paraphraseLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(partOfSpeechLabel.snp.right).offset(10)
            maker.width.equalTo(self.view).offset(-156)
            maker.centerY.equalTo(partOfSpeechLabel)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

