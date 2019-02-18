//
//  SettingViewController.swift
//  News
//
//  Created by Rion on 2019/2/18.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import Kingfisher

class SettingViewController: UITableViewController {
    
    //存储plist文件的数据
    var sections = [[SettingModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getDiskCach()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = sections[section]
        return rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView._dequeueReusableCell(indexPath: indexPath) as SettingCell
        let rows = sections[indexPath.section]
        cell.setting = rows[indexPath.row]
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: //清理缓存
                NotificationCenter.default.addObserver(self, selector: #selector(loadDiskCache), name: NSNotification.Name(rawValue: "cacheSizeM"), object: nil)
//            case 1:
            default:
                break
            }
//        case 1:
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 8))
        view.theme_backgroundColor = "colors.tableViewBackgroundColor"
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:  //清理缓存
                clearCacheAlertController()
            //            case 1:
            default:
                break
            }
        //        case 1:
        default:
            break
        }
        
    }

}

extension SettingViewController {
    
    fileprivate func setupUI() {
        let path = Bundle.main.path(forResource: "Setting", ofType: "plist")
        let cellPlist = NSArray(contentsOfFile: path!) as! [Any]
        for dicts in cellPlist {
            let array = dicts as! [[String: Any]]
            var rows = [SettingModel]()
            for dict in array {
                let setting = SettingModel.deserialize(from: dict as NSDictionary)
                rows.append(setting!)
            }
            sections.append(rows)
        }
        tableView._registerCell(cell: SettingCell.self)
        
        tableView.rowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.theme_backgroundColor = "colors.tableViewBackgroundColor"
    }
}

extension SettingViewController {
    //从沙盒中获取缓存数据size
    fileprivate func getDiskCach()  {
        let cache = KingfisherManager.shared.cache
        cache.calculateDiskStorageSize { (size) in
            let sizeM = Double(size.value!) / 1024.0 / 1024.0
            let sizeString = String(format: "%.2fM", sizeM)
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cacheSizeM"), object: self, userInfo: ["cacheSize": sizeString])
        }
    }
    
    //获取缓存显示到cell
    @objc fileprivate func loadDiskCache(notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let indexpath = IndexPath(item: 0, section: 0)
        let cell = tableView.cellForRow(at: indexpath) as! SettingCell
        cell.rightLabel.text = (userInfo["cacheSize"] as? String)!
    }
    
    fileprivate func clearCacheAlertController(){
        let alertController = UIAlertController(title:"清理所有缓存？", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "确定", style: .default, handler: { (_) in
            let cache = KingfisherManager.shared.cache
            cache.clearDiskCache()
            cache.clearMemoryCache()
            cache.cleanExpiredDiskCache()
            let sizeString = "0.0M"
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cacheSizeM"), object: self, userInfo: ["cacheSize": sizeString])
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
}
