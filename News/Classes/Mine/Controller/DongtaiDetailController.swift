//
//  DongtaiDetailController.swift
//  News
//
//  Created by Rion on 2019/3/13.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import SVProgressHUD

class DongtaiDetailController: UITableViewController {
    
    var dongtai = UserDetailDongtai() {
        didSet {
            navigationBar.user = dongtai.user
            headerView.dongtai = dongtai
        }
    }

    lazy var navigationBar: DongtaiNavigationView = {
        let navView = DongtaiNavigationView.loadViewFromNib()
        return navView
    }()
    lazy var headerView: DongtaiDetailHeaderView = {
        let header = DongtaiDetailHeaderView.loadViewFromNib()
        return header
    }()
    
    var comments = [DongtaiComment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.configuration()
        setupUI()
        onActionClick()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

extension DongtaiDetailController {
    
    func setupUI() {
        
        tableView.theme_backgroundColor = "colors.cellBackgroundColor"
        navigationItem.titleView = navigationBar
    
        ThemeStyle.setNavigationStyle(self, UserDefaults.standard.bool(forKey: isNight))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: UserDefaults.standard.bool(forKey: isNight) ? "new_more_titlebar_night_24x24_" : "new_more_titlebar_24x24_"), style: .plain, target: self, action: #selector(rightBarClick))
        
        //接收更换主题通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightClick), name: NSNotification.Name(rawValue: "dayOrNightClick"), object: nil)
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        
        tableView._registerCell(cell: DongtaiCommentCell.self)
        
        switch dongtai.item_type {
        case .commentOrQuoteContent, .commentOrQuoteOthers, .forwardArticle:
            tableView.mj_footer = RefreshFooter(refreshingBlock: { [weak self] in
                Network.loadUserDetailQuoteComments(detailId: self!.dongtai.id, offset: self!.comments.count) { (comments) in
                    self!.loadData(comments: comments)
                }
            })
        case .postContent:
            tableView.mj_footer = RefreshFooter(refreshingBlock: { [weak self] in
                Network.loadUserDetailNormalComments(groupId: Int(self!.dongtai.id_str)!, count: 20, offset: self!.comments.count) { (comments) in
                    self!.loadData(comments: comments)
                }
            })
        default:
            break
        }
        tableView.mj_footer.beginRefreshing()
        
    }
    
    func loadData(comments: [DongtaiComment]) {
        if tableView.mj_footer.isRefreshing {
            tableView.mj_footer.endRefreshing()
        }
        tableView.mj_footer.pullingPercent = 0
        if comments.count == 0 {
            tableView.mj_footer.endRefreshingWithNoMoreData()
            SVProgressHUD.showInfo(withStatus: "没有更多数据")
            return
        }
        self.comments = comments
        tableView.reloadData()
    }
    
    @objc func receiveDayOrNightClick(notification: Notification) {
        ThemeStyle.setNavigationStyle(self, notification.object as! Bool)
    }
    
    @objc func rightBarClick() {
        
    }
    
    func onActionClick() {
        headerView.didClickDigg = { [weak self] dongtai in
            let userDiggVC = UserDiggController()
            userDiggVC.detailId = dongtai.id
            self!.navigationController?.pushViewController(userDiggVC, animated: true)
        }
    }
}

extension DongtaiDetailController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView._dequeueReusableCell(indexPath: indexPath) as DongtaiCommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationBar.titleLabel.isHidden = scrollView.contentOffset.y >= 50
        navigationBar.nameButton.isHidden = scrollView.contentOffset.y <= 50
        navigationBar.avatarButton.isHidden = scrollView.contentOffset.y <= 50
        navigationBar.followersButton.isHidden = scrollView.contentOffset.y <= 50
        navigationBar.vipImage.isHidden = scrollView.contentOffset.y <= 50
    }
}
