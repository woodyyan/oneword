//
//  ImageCreator.swift
//  OneWord
//
//  Created by Songbai Yan on 30/06/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit

class ImageCreator {
    class func createWordImage(for word:Word) -> UIImage{
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 365))
        mainView.backgroundColor = UIColor.white
        
        let dateLabel = UILabel()
        dateLabel.textColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.text = getDateText()
        mainView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(mainView).offset(20)
            maker.right.equalTo(mainView).offset(-20)
        }
        
        let dateLine = UIView()
        dateLine.backgroundColor = UIColor(red: 237/255, green: 234/255, blue: 234/255, alpha: 1)
        mainView.addSubview(dateLine)
        dateLine.snp.makeConstraints { (maker) in
            maker.height.equalTo(1)
            maker.width.equalTo(dateLabel)
            maker.top.equalTo(dateLabel.snp.bottom).offset(5)
            maker.left.equalTo(dateLabel)
        }
        
        let wordLinesImage = UIImageView(image: UIImage(named: "lines"))
        mainView.addSubview(wordLinesImage)
        wordLinesImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(mainView).offset(20)
            maker.top.equalTo(dateLine).offset(35)
            maker.right.equalTo(mainView).offset(-20)
        }
        
        let wordLabel = UILabel()
        wordLabel.text = word.text
        wordLabel.font = UIFont.systemFont(ofSize: 22)
        wordLabel.textColor = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1)
        mainView.addSubview(wordLabel)
        wordLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(wordLinesImage)
            maker.left.equalTo(wordLinesImage).offset(20)
        }
        
        let soundmarkLinesImage = UIImageView(image: UIImage(named: "lines"))
        mainView.addSubview(soundmarkLinesImage)
        soundmarkLinesImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(mainView).offset(20)
            maker.top.equalTo(wordLinesImage.snp.bottom).offset(35)
            maker.right.equalTo(mainView).offset(-20)
        }
        
        let soundmarkLabel = UILabel()
        soundmarkLabel.text = word.soundmark
        soundmarkLabel.font = UIFont.systemFont(ofSize: 18)
        soundmarkLabel.textColor = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1)
        mainView.addSubview(soundmarkLabel)
        soundmarkLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(soundmarkLinesImage)
            maker.left.equalTo(soundmarkLinesImage).offset(20)
        }
        
        let paraphraseLinesImage = UIImageView(image: UIImage(named: "lines"))
        mainView.addSubview(paraphraseLinesImage)
        paraphraseLinesImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(mainView).offset(20)
            maker.top.equalTo(soundmarkLinesImage.snp.bottom).offset(35)
            maker.right.equalTo(mainView).offset(-20)
        }
        
        let paraphraseLabel = UILabel()
        paraphraseLabel.text = word.partOfSpeech + " " + word.paraphrase
        paraphraseLabel.font = UIFont.systemFont(ofSize: 18)
        paraphraseLabel.textColor = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1)
        mainView.addSubview(paraphraseLabel)
        paraphraseLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(paraphraseLinesImage)
            maker.left.equalTo(paraphraseLinesImage).offset(20)
        }
        
        let logoImage = UIImageView(image: UIImage(named: "logo"))
        mainView.addSubview(logoImage)
        logoImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(mainView).offset(20)
            maker.bottom.equalTo(mainView).offset(-10)
            maker.width.equalTo(25)
            maker.height.equalTo(25)
        }
        
        let appNameLabel = UILabel()
        appNameLabel.text = "随记单词"
        appNameLabel.font = UIFont.systemFont(ofSize: 12)
        appNameLabel.textColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        mainView.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(logoImage.snp.right).offset(10)
            maker.centerY.equalTo(logoImage)
        }
        
        //不加到VC里无法渲染出图片
        let vc = UIViewController()
        vc.view.addSubview(mainView)
        
        let size = CGSize(width: mainView.frame.size.width, height: mainView.frame.size.height)
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        mainView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return image!
    }
    
    private class func createFolder(with folderUrl: URL){
        let manager = FileManager.default
        let exist = manager.fileExists(atPath: folderUrl.path)
        
        if !exist {
            do {
                try manager.createDirectory(at: folderUrl,withIntermediateDirectories: true,attributes: nil)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    class func saveImageToFile(with name:String, image:UIImage) -> URL? {
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in:FileManager.SearchPathDomainMask.userDomainMask)
        let url = urlForDocument[0]
        let folder = url.appendingPathComponent("wordImages",isDirectory: true)
        createFolder(with: folder)
        let imageUrl = folder.appendingPathComponent("\(name).jpg")
        
        let exist = manager.fileExists(atPath: imageUrl.path)
        if !exist{
            
            let imageData = UIImageJPEGRepresentation(image, 1)
            do{
                try imageData?.write(to: URL(fileURLWithPath: imageUrl.path), options: [.atomic])
                return imageUrl
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    private class func getDateText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateText = dateFormatter.string(from: Date())
        return dateText
    }
}
