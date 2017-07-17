//
//  SettingsViewController.swift
//  OneWord
//
//  Created by Songbai Yan on 12/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    fileprivate let service = AboutService()
    fileprivate var appStoreUrl = "https://itunes.apple.com/us/app/id1227214796"
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置"
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
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.section {
        case 0:
            return getCell(.push)
        case 1:
            switch indexPath.row {
            case 0:
                return getCell(.recommand)
            case 1:
                return getCell(.comment)
            default:
                return UITableViewCell()
            }
        case 2:
            return getCell(.about)
        default: fatalError("Unknown number of sections")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.navigationController?.pushViewController(WordPushSettingsViewController(), animated: true)
        case 1:
            switch indexPath.row {
            case 0:
                recommandToFriends()
            case 1:
                commentAppInStore()
            default:
                break
            }
        case 2:
            self.navigationController?.pushViewController(AboutViewController(), animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private Methods
    fileprivate func commentAppInStore() {
        if let url = URL(string: appStoreUrl) {
            UIApplication.shared.open(url, options: [String : Any](), completionHandler: nil)
        }
    }
    
    fileprivate func recommandToFriends() {
        if let url = URL(string: appStoreUrl) {
            let controller = UIActivityViewController(activityItems: ["推荐「随记单词」给你", url], applicationActivities: [])
            controller.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks]
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    fileprivate func getCell(_ cellType:CellType) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        switch cellType {
        case .push:
            cell.textLabel?.text = "单词推送频率"
        case .recommand:
            cell.textLabel?.text = "告诉小伙伴"
        case .comment:
            cell.textLabel?.text = "给我们评分"
        case .about:
            let newCell = UITableViewCell(style: .value1, reuseIdentifier:"about")
            newCell.textLabel?.text = "关于"
            newCell.detailTextLabel?.text = service.getCurrentVersion()
            newCell.accessoryType = .disclosureIndicator
            return newCell
        }
        return cell
    }
}

fileprivate enum CellType {
    case push
    case recommand
    case comment
    case about
}


