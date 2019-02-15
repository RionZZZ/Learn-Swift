//
//  MineViewController.swift
//  News
//
//  Created by Rion on 2019/2/14.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class MineViewController: UITableViewController {

    var sections = [[MineCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.globalBgc()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: String(describing : MineOtherCell.self), bundle: nil), forCellReuseIdentifier: String(describing : MineOtherCell.self))
        tableView.register(UINib(nibName: String(describing : MineFirstSectionCell.self), bundle: nil), forCellReuseIdentifier: String(describing : MineFirstSectionCell.self))
        
        Network.loadMineCellData { sections in
            let str = "{\"text\":\"我的关注\",\"grey_text\":\"\"}"
            let mineConcern = MineCellModel.deserialize(from: str)
            var mineConcerns = [MineCellModel]()
            mineConcerns.append(mineConcern!)
            self.sections.append(mineConcerns)
            self.sections += sections
            self.tableView.reloadData()
        }
    }
}

extension MineViewController {
    
    //每组头部高度
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 0 : 10
    }
    //头部视图
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 10))
        view.backgroundColor = UIColor.globalBgc()
        return view
    }
    //cell高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    //组数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    //cell数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    //cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing : MineFirstSectionCell.self)) as! MineFirstSectionCell
            
            let section = sections[indexPath.section]
            let mineCellModel = section[indexPath.row]
            cell.leftLabel.text = mineCellModel.text
            cell.rightLabel.text = mineCellModel.grey_text
            return cell
        }
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing : MineOtherCell.self)) as! MineOtherCell
        let section = sections[indexPath.section]
        let mineCellModel = section[indexPath.row]
//        cell.textLabel?.text = mineCellModel.text
        cell.leftLabel.text = mineCellModel.text
        cell.rightLabel.text = mineCellModel.grey_text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
