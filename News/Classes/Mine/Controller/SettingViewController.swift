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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
//        getDiskCach()
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
//                NotificationCenter.default.addObserver(self, selector: #selector(loadDiskCache), name: NSNotification.Name(rawValue: "cacheSizeM"), object: nil)
                getDiskCach(cell)
            case 1: break //设置字体大小
//                NotificationCenter.default.addObserver(self, selector: #selector(changeFontSize), name: NSNotification.Name(rawValue: "fontSize"), object: nil)
            case 2:
                cell.selectionStyle = .none
            case 3: break //非Wi-Fi网络流量
//                NotificationCenter.default.addObserver(self, selector: #selector(changeNetworkMode), name: NSNotification.Name(rawValue: "networkMode"), object: nil)
            case 4: break //非Wi-Fi网络播放提醒
//                NotificationCenter.default.addObserver(self, selector: #selector(changeNetworkWarn), name: NSNotification.Name(rawValue: "networkWarn"), object: nil)
            case 5:
                cell.selectionStyle = .none
            default:
                break
            }
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
        let cell = tableView.cellForRow(at: indexPath) as! SettingCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:  //清理缓存
                clearCacheAlertController(cell)
            case 1:  //设置字体大小
                setupFontAlertController(cell)
            case 3:  //设置网络
                setupNetworkAlertController(cell)
            case 4:  //设置网络提醒
                setupNetworkWarnAlertController(cell)
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0://离线下载
                let OfflineDownloadVC = OfflineDownloadController()
                OfflineDownloadVC.navigationItem.title = "离线下载"
                navigationController?.pushViewController(OfflineDownloadVC, animated: true)
            default:
                break
            }
        default:
            break
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension SettingViewController {
    
    fileprivate func setupUI() {
        let path = Bundle.main.path(forResource: "Setting", ofType: "plist")
        let cellPlist = NSArray(contentsOfFile: path!) as! [Any]
//        for dicts in cellPlist {
//            let array = dicts as! [[String: Any]]
//            var rows = [SettingModel]()
//            for dict in array {
//                let setting = SettingModel.deserialize(from: dict as NSDictionary)
//                rows.append(setting!)
//            }
//            sections.append(rows)
//        }
        sections = cellPlist.compactMap({section in
            (section as! [Any]).compactMap({dict in
                SettingModel.deserialize(from: dict as? NSDictionary)
            })
        })
        tableView._registerCell(cell: SettingCell.self)
        
        tableView.rowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.theme_backgroundColor = "colors.tableViewBackgroundColor"
    }
}

extension SettingViewController {
    //从沙盒中获取缓存数据size
    fileprivate func getDiskCach(_ cell: SettingCell)  {
        let cache = KingfisherManager.shared.cache
        cache.calculateDiskStorageSize { (size) in
            let sizeM = Double(size.value!) / 1024.0 / 1024.0
            let sizeString = String(format: "%.2fM", sizeM)
            //发送通知
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cacheSizeM"), object: self, userInfo: ["cacheSize": sizeString])
            cell.rightLabel.text = sizeString
        }
    }
    
    //获取缓存显示到cell
    @objc fileprivate func loadDiskCache(notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let indexpath = IndexPath(item: 0, section: 0)
        let cell = tableView.cellForRow(at: indexpath) as! SettingCell
        cell.rightLabel.text = (userInfo["cacheSize"] as? String)!
    }
    
    //从沙盒中清除所有缓存数据
    fileprivate func clearCacheAlertController(_ cell: SettingCell){
        let alertController = UIAlertController(title:"清理所有缓存？", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "确定", style: .default, handler: { (_) in
            let cache = KingfisherManager.shared.cache
            cache.clearDiskCache()
            cache.clearMemoryCache()
            cache.cleanExpiredDiskCache()
            let sizeString = "0.0M"
            //发送通知
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cacheSizeM"), object: self, userInfo: ["cacheSize": sizeString])
            cell.rightLabel.text = sizeString
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //设置页面字体大小
    fileprivate func setupFontAlertController(_ cell: SettingCell){
        let alertController = UIAlertController(title:"设置字体大小", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let smallAction = UIAlertAction(title: "小", style: .default, handler: { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fontSize"), object: self, userInfo: ["fontSize": "小"])
            cell.rightLabel.text = "小"
        })
        let middleAction = UIAlertAction(title: "中", style: .default, handler: { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fontSize"), object: self, userInfo: ["fontSize": "中"])
            cell.rightLabel.text = "中"
        })
        let bigAction = UIAlertAction(title: "大", style: .default, handler: { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fontSize"), object: self, userInfo: ["fontSize": "大"])
            cell.rightLabel.text = "大"
        })
        let lagerAction = UIAlertAction(title: "特大", style: .default, handler: { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fontSize"), object: self, userInfo: ["fontSize": "特大"])
            cell.rightLabel.text = "特大"
        })
        alertController.addAction(cancelAction)
        alertController.addAction(smallAction)
        alertController.addAction(middleAction)
        alertController.addAction(bigAction)
        alertController.addAction(lagerAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //获取字体大小
    @objc fileprivate func changeFontSize(notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let indexpath = IndexPath(item: 1, section: 0)
        let cell = tableView.cellForRow(at: indexpath) as! SettingCell
        cell.rightLabel.text = (userInfo["fontSize"] as? String)!
    }
    
    //获取网络流量
    fileprivate func setupNetworkAlertController(_ cell: SettingCell){
        let alertController = UIAlertController(title:"设置非Wi-Fi网络流量", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let bestAction = UIAlertAction(title: "最佳效果（下载大图）", style: .default, handler: { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkMode"), object: self, userInfo: ["networkMode": "最佳效果（下载大图）"])
            cell.rightLabel.text = "最佳效果（下载大图）"
        })
        let betterAction = UIAlertAction(title: "较省效果（智能下图）", style: .default, handler: { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkMode"), object: self, userInfo: ["networkMode": "较省效果（智能下图）"])
            cell.rightLabel.text = "较省效果（智能下图）"
        })
        let leastAction = UIAlertAction(title: "极省效果（智能下图）", style: .default, handler: { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkMode"), object: self, userInfo: ["networkMode": "极省效果（智能下图）"])
            cell.rightLabel.text = "极省效果（智能下图）"
        })
        alertController.addAction(cancelAction)
        alertController.addAction(leastAction)
        alertController.addAction(betterAction)
        alertController.addAction(bestAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //设置网络流量
    @objc fileprivate func changeNetworkMode(notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let indexpath = IndexPath(item: 3, section: 0)
        let cell = tableView.cellForRow(at: indexpath) as! SettingCell
        cell.rightLabel.text = (userInfo["networkMode"] as? String)!
    }
    
    //获取网络流量提醒
    fileprivate func setupNetworkWarnAlertController(_ cell: SettingCell){
        let alertController = UIAlertController(title:"设置非Wi-Fi网络播放提醒", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let onceAction = UIAlertAction(title: "提醒一次", style: .default, handler: { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkWarn"), object: self, userInfo: ["networkWarn": "提醒一次"])
            cell.rightLabel.text = "提醒一次"
        })
        let everyAction = UIAlertAction(title: "每次提醒", style: .default, handler: { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkWarn"), object: self, userInfo: ["networkWarn": "每次提醒"])
            cell.rightLabel.text = "每次提醒"
        })
        alertController.addAction(cancelAction)
        alertController.addAction(onceAction)
        alertController.addAction(everyAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //设置网络流量提醒
    @objc fileprivate func changeNetworkWarn(notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let indexpath = IndexPath(item: 4, section: 0)
        let cell = tableView.cellForRow(at: indexpath) as! SettingCell
        cell.rightLabel.text = (userInfo["networkWarn"] as? String)!
    }
}
