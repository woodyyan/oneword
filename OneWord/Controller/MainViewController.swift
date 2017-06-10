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
    fileprivate let service = MainService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "随记单词"
        self.view.backgroundColor = UIColor.white
        
        initWordUI()
        initWriteBoardView()
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
    
    private func initWordUI(){
        //防止scrollview自适应navigationbar的高度，避免出现单词闪动的情况
        self.automaticallyAdjustsScrollViewInsets = false
        
        var barHeight:CGFloat = 0
        if let tempBarHeight = self.navigationController?.navigationBar.frame.height{
            barHeight = tempBarHeight
        }
        
        let statusBarHeight:CGFloat = 22
        let topOffset = barHeight + statusBarHeight
        let scrollViewHeight = self.view.bounds.height - topOffset
        
        let firstWord = service.getRandomWord()
        let firstWordView = WordView(frame: self.view.frame)
        firstWordView.wordLabel.text = firstWord.text
        firstWordView.soundmarkLabel.text = firstWord.soundmark
        firstWordView.partOfSpeechLabel.text = firstWord.partOfSpeech
        firstWordView.paraphraseLabel.text = firstWord.paraphrase
        
        let secondWord = service.getRandomWord()
        let secondWordView = WordView(frame: self.view.frame)
        secondWordView.wordLabel.text = secondWord.text
        secondWordView.soundmarkLabel.text = secondWord.soundmark
        secondWordView.partOfSpeechLabel.text = secondWord.partOfSpeech
        secondWordView.paraphraseLabel.text = secondWord.paraphrase
        
        let thirdWord = service.getRandomWord()
        let thirdWordView = WordView(frame: self.view.frame)
        thirdWordView.wordLabel.text = thirdWord.text
        thirdWordView.soundmarkLabel.text = thirdWord.soundmark
        thirdWordView.partOfSpeechLabel.text = thirdWord.partOfSpeech
        thirdWordView.paraphraseLabel.text = thirdWord.paraphrase
        
        let loopView = CircularlyPagedScrollView(frame: self.view.frame, viewsToRotate: [firstWordView, secondWordView, thirdWordView], scrollHorizontally: true)
        loopView.circularlyPagedDelegate = self
        loopView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(3), height: scrollViewHeight)
        loopView.resetMiddleViewShown(middle: loopView.viewsToRotate[2])
        self.view.addSubview(loopView)
        loopView.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.view)
            maker.height.equalTo(self.view)
            maker.left.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController : CircularlyPagedDelegate{
    func circularlyPagedScrollView(updated views: [UIView], view: CircularlyPagedScrollView) {
        if views.count > 2{
            if let thirdView = views[2] as? WordView{
                let thirdWord = service.getRandomWord()
                thirdView.wordLabel.text = thirdWord.text
                thirdView.soundmarkLabel.text = thirdWord.soundmark
                thirdView.partOfSpeechLabel.text = thirdWord.partOfSpeech
                thirdView.paraphraseLabel.text = thirdWord.paraphrase
            }
        }
    }
}

