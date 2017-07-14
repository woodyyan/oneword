//
//  WordPushSettingsViewController.swift
//  OneWord
//
//  Created by Songbai Yan on 14/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit

class WordPushSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "单词推送频率"
        self.view.backgroundColor = UIColor.white
        
        let tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch(section) {
        case 0:
            return 7
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row {
        case 0:
            return getCell(text: "1次／天")
        case 1:
            return getCell(text: "3次／天")
        case 2:
            return getCell(text: "5次／天")
        case 3:
            return getCell(text: "8次／天")
        case 4:
            return getCell(text: "12次／天")
        case 5:
            return getCell(text: "16次／天")
        case 6:
            return getCell(text: "关闭")
        default: fatalError("Unknown number of sections")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func getCell(text:String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = text
        return cell
    }
}

