//
//  OfflineDownloadController.swift
//  News
//
//  Created by Rion on 2019/2/18.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class OfflineDownloadController: UITableViewController {

    fileprivate var titles = [HomeNewsTitleModel]()
    
    fileprivate let newsTitleTable = NewsTitleTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView._registerCell(cell: OfflineDownloadCell.self)
        
        tableView.rowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.theme_backgroundColor = "colors.tableViewBackgroundColor"
        tableView.theme_separatorColor = "colors.separatorColor"
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //解决reloadRows最后几行会抖动的问题
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
//        Network.loadHomeNewsTitle(completionHandler: { titles in
//            self.titles = titles
//            self.tableView.reloadData()
//        })
        self.titles = newsTitleTable.selectAll()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView._dequeueReusableCell(indexPath: indexPath) as OfflineDownloadCell
        let newsTitle = titles[indexPath.row]
        cell.titleLabel.text = newsTitle.name
        cell.rightImage.theme_image = newsTitle.selected ? "images.air_download_press" : "images.air_download"
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        view.theme_backgroundColor = "colors.tableViewBackgroundColor"
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: screenWidth, height: 44))
        label.text = "我的频道"
        label.theme_textColor = "colors.black"
        let separator = UIView(frame: CGRect(x: 0, y: 43, width: screenWidth, height: 1))
        separator.theme_backgroundColor = "colors.separatorColor"
        view.addSubview(label)
        view.addSubview(separator)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var homeNewsTitle = titles[indexPath.row]
        homeNewsTitle.selected = !homeNewsTitle.selected
        let cell = tableView.cellForRow(at: indexPath) as! OfflineDownloadCell
        cell.rightImage.theme_image = homeNewsTitle.selected ? "images.air_download_press" : "images.air_download"
        titles[indexPath.row] = homeNewsTitle
        newsTitleTable.update(homeNewsTitle)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
   
}
