//
//  ViewController.swift
//  OneWord
//
//  Created by Songbai Yan on 15/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit
import SnapKit
import NotificationBanner

class MainViewController: UIViewController {
    fileprivate let wordTextKey = "wordText"
    fileprivate let soundmarkKey = "soundmark"
    fileprivate let partOfSpeechKey = "partOfSpeech"
    fileprivate let paraphraseKey = "paraphrase"
    
    fileprivate let service = MainService()
    
    private var paintBoard:PaintView!
    private var loopView:CircularlyPagedScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "随记单词"
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "about"), style: .plain, target: self, action: #selector(MainViewController.aboutClick(sender:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "guide"), style: .plain, target: self, action: #selector(MainViewController.guideClick(sender:)))
        
        initWordUI()
        initWriteBoardView()
        
        showTipsIfFirstTime()
    }
    
    private func initWriteBoardView(){
        let boardView = UIView()
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
        
        paintBoard = PaintView(frame: boardView.frame)
        paintBoard.lineWidth = 2
        paintBoard.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        boardView.addSubview(paintBoard)
        paintBoard.snp.makeConstraints { (maker) in
            maker.top.equalTo(boardView)
            maker.left.equalTo(boardView)
            maker.right.equalTo(boardView)
            maker.bottom.equalTo(boardView)
        }
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "clear"), for: .normal)
        clearButton.addTarget(self, action: #selector(MainViewController.clearBoard(sender:)), for: .touchUpInside)
        boardView.addSubview(clearButton)
        clearButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(boardView)
            maker.top.equalTo(boardView)
            maker.width.equalTo(35)
            maker.height.equalTo(35)
        }
        
        let shareButton = UIButton(type: .custom)
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.addTarget(self, action: #selector(MainViewController.shareClick(sender:)), for: .touchUpInside)
        self.view.addSubview(shareButton)
        shareButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(boardView.snp.top)
            maker.width.equalTo(35)
            maker.height.equalTo(35)
        }
    }
    
    func shareClick(sender:UIButton){
        let isFirstWord = loopView.contentOffset.x == 0
        var word:Word?
        if isFirstWord{
            if let firstView = loopView.viewsShown[0] as? WordView{
                let text = firstView.wordLabel.text!
                let soundmark = firstView.soundmarkLabel.text!
                let partOfSpeech = firstView.partOfSpeechLabel.text!
                let paraphrase = firstView.paraphraseLabel.text!
                word = Word(text: text, soundmark: soundmark, partOfSpeech: partOfSpeech, paraphrase: paraphrase)
            }
        }else{
            if let secondView = loopView.viewsShown[1] as? WordView{
                let text = secondView.wordLabel.text!
                let soundmark = secondView.soundmarkLabel.text!
                let partOfSpeech = secondView.partOfSpeechLabel.text!
                let paraphrase = secondView.paraphraseLabel.text!
                word = Word(text: text, soundmark: soundmark, partOfSpeech: partOfSpeech, paraphrase: paraphrase)
            }
        }
        
        shareWord(word)
    }
    
    func shareWord(_ word:Word?){
        if word == nil{
            let banner = NotificationBanner(title: "分享失败", style: .warning)
            banner.show()
        }
        
        let image = ImageCreator.createWordImage(for: word!)
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: [])
        controller.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks]
        self.present(controller, animated: true, completion: nil)
    }
    
    func aboutClick(sender: UIBarButtonItem){
        self.navigationController?.pushViewController(AboutViewController(), animated: true)
    }
    
    func guideClick(sender: UIBarButtonItem){
        self.navigationController?.pushViewController(GuideViewController(), animated: true)
    }
    
    func clearBoard(sender:UIButton){
        paintBoard.cleanAll()
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
        
        var secondWord = service.getRandomWord()
        if let localFirstWord = getFirstWordFromLocalDefaults(){
            secondWord = localFirstWord
        }
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
        
        loopView = CircularlyPagedScrollView(frame: self.view.frame, viewsToRotate: [firstWordView, secondWordView, thirdWordView], scrollHorizontally: true)
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
    
    private func getFirstWordFromLocalDefaults() -> Word?{
        guard let wordText = UserDefaults.standard.string(forKey: wordTextKey) else{
            return nil
        }
        guard let soundmark = UserDefaults.standard.string(forKey: soundmarkKey) else{
            return nil
        }
        guard let partOfSpeech = UserDefaults.standard.string(forKey: partOfSpeechKey) else{
            return nil
        }
        guard let paraphrase = UserDefaults.standard.string(forKey: paraphraseKey) else{
            return nil
        }
        return Word(text: wordText, soundmark: soundmark, partOfSpeech: partOfSpeech, paraphrase: paraphrase)
    }
}

extension MainViewController : CircularlyPagedDelegate{
    func circularlyPagedScrollView(updated views: [UIView], view: CircularlyPagedScrollView) {
        if views.count > 2{
            if let thirdView = views[2] as? WordView{
                update(third: thirdView)
            }
            
            if let middleView = views[1] as? WordView{
                let word = middleView.wordLabel.text
                let soundmark = middleView.soundmarkLabel.text
                let partOfSpeech = middleView.partOfSpeechLabel.text
                let paraphrase = middleView.paraphraseLabel.text
                save(current: word, soundmark: soundmark, partOfSpeech: partOfSpeech, paraphrase: paraphrase)
            }
        }
    }
    
    private func save(current text:String?, soundmark:String?, partOfSpeech:String?, paraphrase:String?){
        UserDefaults.standard.set(text, forKey: wordTextKey)
        UserDefaults.standard.set(soundmark, forKey: soundmarkKey)
        UserDefaults.standard.set(partOfSpeech, forKey: partOfSpeechKey)
        UserDefaults.standard.set(paraphrase, forKey: paraphraseKey)
        UserDefaults.standard.synchronize()
    }
    
    private func update(third wordView:WordView){
        let thirdWord = service.getRandomWord()
        wordView.wordLabel.text = thirdWord.text
        wordView.soundmarkLabel.text = thirdWord.soundmark
        wordView.partOfSpeechLabel.text = thirdWord.partOfSpeech
        wordView.paraphraseLabel.text = thirdWord.paraphrase
    }
}

extension MainViewController{
    fileprivate static let tipsKey = "MainPageFirstTimeTipsKey"
    
    func showTipsIfFirstTime(){
        if isFirstTime(){
            showTipsView()
            
            UserDefaults.standard.set(true, forKey: MainViewController.tipsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    fileprivate func isFirstTime() -> Bool{
        let hasShown = UserDefaults.standard.bool(forKey: MainViewController.tipsKey)
        return !hasShown
    }
    
    fileprivate func showTipsView(){
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.3
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainViewController.handleTapEvent(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
        
        let tipWriteImage = UIImageView(image: UIImage(named: "tip_write"))
        backgroundView.addSubview(tipWriteImage)
        tipWriteImage.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(backgroundView)
            maker.bottom.equalTo(backgroundView).offset(-100)
        }
        
        let writeLabel = UILabel()
        writeLabel.text = "手写"
        writeLabel.textColor = UIColor.white
        writeLabel.font = UIFont.systemFont(ofSize: 14)
        backgroundView.addSubview(writeLabel)
        writeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(tipWriteImage.snp.bottom).offset(5)
            maker.centerX.equalTo(tipWriteImage)
        }
        
        let tipLeftImage = UIImageView(image: UIImage(named: "tip_left"))
        backgroundView.addSubview(tipLeftImage)
        tipLeftImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(backgroundView).offset(35)
            maker.bottom.equalTo(backgroundView).offset(-290)
        }
        
        let tipRightImage = UIImageView(image: UIImage(named: "tip_right"))
        backgroundView.addSubview(tipRightImage)
        tipRightImage.snp.makeConstraints { (maker) in
            maker.right.equalTo(backgroundView).offset(-35)
            maker.bottom.equalTo(backgroundView).offset(-290)
        }
        
        let tipClearImage = UIImageView(image: UIImage(named: "tip_clear"))
        backgroundView.addSubview(tipClearImage)
        tipClearImage.snp.makeConstraints { (maker) in
            maker.right.equalTo(backgroundView).offset(-2)
            maker.top.equalTo(backgroundView.snp.bottom).offset(-220)
        }
        
        let clearLabel = UILabel()
        clearLabel.text = "清除"
        clearLabel.textColor = UIColor.white
        clearLabel.font = UIFont.systemFont(ofSize: 14)
        backgroundView.addSubview(clearLabel)
        clearLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(tipClearImage.snp.bottom).offset(5)
            maker.centerX.equalTo(tipClearImage)
        }
        
        UIApplication.shared.keyWindow!.addSubview(backgroundView)
    }
    
    func handleTapEvent(_ sender:UITapGestureRecognizer){
        sender.view?.removeFromSuperview()
    }
}


