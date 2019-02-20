//
//  UserDetailViewController.swift
//  News
//
//  Created by Rion on 2019/2/19.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    
    var userId: Int = 0
    var userDetail: UserDetail?
    
    //懒加载header
    fileprivate lazy var headerView: UserDetailHeaderView = {
        let headerView = UserDetailHeaderView.headerView()
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.addSubview(headerView)
        scrollView.contentSize = CGSize(width: screenWidth, height: 1000)
        bottomViewBottom.constant = isBigPhone ? safeAreaBottom! : 0
        view.layoutIfNeeded()
        
        Network.loadUserDetail(user_id: userId) { (userDetail) in
            self.userDetail = userDetail
            self.headerView.userDetail = userDetail
            if userDetail.bottom_tab.count == 0 {
                self.bottomViewBottom.constant = 0
                self.view.layoutIfNeeded()
            } else {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}
