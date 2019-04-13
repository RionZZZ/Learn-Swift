//
//  UserDiggController.swift
//  News
//
//  Created by Rion on 2019/4/13.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserDiggController: UITableViewController {
    
    var detailId = 0
    var digglist = [DongtaiUserDigg]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "赞过的人"
        SVProgressHUD.configuration()

        tableView._registerCell(cell: UserDiggCell.self)
        tableView.tableFooterView = UIView()
        tableView.mj_footer = RefreshFooter(refreshingBlock: { [weak self] in
            Network.loadUserDongtaiDetailDiggList(detailId: self!.detailId, offset: self!.digglist.count) { (digglist) in
                if self!.tableView.mj_footer.isRefreshing {
                    self!.tableView.mj_footer.endRefreshing()
                }
                self!.tableView.mj_footer.pullingPercent = 0
                if digglist.count == 0 {
                    self!.tableView.mj_footer.endRefreshingWithNoMoreData()
                    SVProgressHUD.showInfo(withStatus: "没有更多数据")
                    return
                }
                self!.digglist = digglist
                self!.tableView.reloadData()
            }
        })
        tableView.mj_footer.beginRefreshing()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return digglist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView._dequeueReusableCell(indexPath: indexPath) as UserDiggCell
        cell.user = digglist[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailVC = UserDetailViewController2()
        userDetailVC.userId = digglist[indexPath.row].user_id
        navigationController?.pushViewController(userDetailVC, animated: true)
    }
    
}
