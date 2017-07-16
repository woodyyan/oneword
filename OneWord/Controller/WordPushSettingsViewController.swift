//
//  WordPushSettingsViewController.swift
//  OneWord
//
//  Created by Songbai Yan on 14/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit

class WordPushSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    private var lastFrequency = -1
    private var frequency = 3
    private var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "单词推送频率"
        self.view.backgroundColor = UIColor.white
        
        let tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        let tipsLabel = UILabel()
        tipsLabel.numberOfLines = 0
        tipsLabel.textAlignment = .center
        tipsLabel.text = "随记单词会定时推送单词，让你瞄一眼锁屏屏幕就能记住一个单词。推送通知不会有声音和振动，请放心开启。"
        tipsLabel.font = UIFont.systemFont(ofSize: 12)
        tipsLabel.textColor = UIColor.gray
        tipsLabel.frame = CGRect(x: 15, y: 0, width: self.view.frame.width - 30, height: 50)
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        footerView.addSubview(tipsLabel)
        tableView.tableFooterView = footerView
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(WordPushSettingsViewController.doneTap(sender:)))
        
        frequency = UserDefaults.standard.integer(forKey: "pushWordFrequency")
        lastFrequency = frequency
    }
    
    func doneTap(sender:UIBarButtonItem){
        if lastFrequency != frequency{
            reesetWordPush()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func reesetWordPush(){
        let service = NotificationService()
        service.updateFrequency(frequency: frequency)
        service.resetNotifications(by: frequency)
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 7
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row {
        case 0:
            let checkmark = frequency == 1
            return getCell(text: "1次／天", checkmark: checkmark)
        case 1:
            let checkmark = frequency == 3
            return getCell(text: "3次／天", checkmark: checkmark)
        case 2:
            let checkmark = frequency == 5
            return getCell(text: "5次／天", checkmark: checkmark)
        case 3:
            let checkmark = frequency == 8
            return getCell(text: "8次／天", checkmark: checkmark)
        case 4:
            let checkmark = frequency == 12
            return getCell(text: "12次／天", checkmark: checkmark)
        case 5:
            let checkmark = frequency == 16
            return getCell(text: "16次／天", checkmark: checkmark)
        case 6:
            let checkmark = frequency == -1
            return getCell(text: "关闭", checkmark: checkmark)
        default: fatalError("Unknown number of sections")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for cell in tableView.visibleCells{
            cell.accessoryType = .none
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        switch indexPath.row {
        case 0:
            frequency = 1
        case 1:
            frequency = 3
        case 2:
            frequency = 5
        case 3:
            frequency = 8
        case 4:
            frequency = 12
        case 5:
            frequency = 16
        case 6:
            frequency = -1
        default:
            frequency = 3
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func getCell(text:String, checkmark:Bool) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = checkmark ? .checkmark : .none
        cell.isSelected = false
        cell.textLabel?.text = text
        return cell
    }
}

