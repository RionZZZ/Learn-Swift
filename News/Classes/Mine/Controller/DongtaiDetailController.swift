//
//  DongtaiDetailController.swift
//  News
//
//  Created by Rion on 2019/3/13.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

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
        
        setupUI()
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
        case .commentOrQuoteContent, .commentOrQuoteOthers:
            Network.loadUserDetailQuoteComments(detailId: dongtai.id, offset: 0) { (comments) in
                self.comments = comments
                self.tableView.reloadData()
            }
        default:
            break
        }
        
    }
    
    @objc func receiveDayOrNightClick(notification: Notification) {
        ThemeStyle.setNavigationStyle(self, notification.object as! Bool)
    }
    
    @objc func rightBarClick() {
        
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
