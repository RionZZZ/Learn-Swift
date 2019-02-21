//
//  UserDetailViewController.swift
//  News
//
//  Created by Rion on 2019/2/19.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    
    var userId: Int = 0
    var userDetail: UserDetail?
    
    //改变状态栏style
    var changeStatusStyle: UIStatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //懒加载header
    fileprivate lazy var headerView: UserDetailHeaderView = {
//        let headerView = UserDetailHeaderView.headerView()
        let headerView = UserDetailHeaderView.loadViewFromNib()
        return headerView
    }()
    
    //懒加载footer
    fileprivate lazy var footerView: UserDetailBottomView = {
        let footerView = UserDetailBottomView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        footerView.delegate = self
        return footerView
    }()
    
    //懒加载bar
    fileprivate lazy var barView: NavigationBarView = {
        let barView = NavigationBarView.loadViewFromNib()
        return barView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.addSubview(headerView)
        view.addSubview(barView)
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
                self.bottomView.addSubview(self.footerView)
                self.footerView.bottomTabs = userDetail.bottom_tab
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return changeStatusStyle
    }

}

extension UserDetailViewController: UserDetailBottomDelegate {
    //底部按钮点击
    func bottomView(clicked button: UIButton, bottomTab: BottomTab) {
        let bottomPushVC = UserDetailBottomPushController()
        bottomPushVC.navigationItem.title = "网页浏览"
        if bottomTab.children.count == 0 {
            print(bottomTab)
            //直接跳转
            bottomPushVC.url = bottomTab.value
            self.navigationController?.pushViewController(bottomPushVC, animated: true)
        } else {
            //弹出子视图
            let storyboard = UIStoryboard(name: "\(UserDetailBottomPopController.self)", bundle: nil)
            let popVC = storyboard.instantiateViewController(withIdentifier: "\(UserDetailBottomPopController.self)") as! UserDetailBottomPopController
            popVC.tabChildren = bottomTab.children
            popVC.modalPresentationStyle = .custom
            popVC.didSelectedChild = {
                bottomPushVC.url = $0.value
                self.navigationController?.pushViewController(bottomPushVC, animated: true)
            }
            let popAnimator = PopAnimator()
            //转换frame
            let rect = footerView.convert(button.frame, to: view)
            let popWidth = (screenWidth - CGFloat(userDetail!.bottom_tab.count + 1) * 20) / CGFloat(userDetail!.bottom_tab.count)
            let popX = CGFloat(button.tag) * (popWidth + 20) + 20
            let popHeight = CGFloat(bottomTab.children.count) * 40 + 25
            popAnimator.presentFrame = CGRect(x: popX, y: rect.origin.y - popHeight, width: popWidth, height: popHeight)
            popVC.transitioningDelegate = popAnimator
            present(popVC, animated: true, completion: nil)
        }
    }
    
}


extension UserDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < -44 {
            //图片拉伸，粘住顶部
            let totalOffset = UserDetailHeaderBGHeight + abs(offsetY)
            let f = totalOffset / UserDetailHeaderBGHeight
            headerView.backgroundImage.frame = CGRect(x: -screenWidth * (f - 1), y: offsetY, width: screenWidth * f, height: totalOffset)
            barView.backgroundColor = UIColor(white: 1, alpha: 0)
        } else {
            var alpha = (offsetY + 44) / (146 - 88)
            alpha = min(alpha, 1)
            barView.backgroundColor = UIColor(white: 1, alpha: alpha)
            if (alpha == 1) {
                //更换导航栏颜色
                changeStatusStyle = .default
                barView.backButton.theme_setImage("images.personal_home_back_black", forState: .normal)
                barView.moreButton.theme_setImage("images.new_more_titlebar", forState: .normal)
            } else {
                changeStatusStyle = .lightContent
                barView.backButton.theme_setImage("images.personal_home_back_white", forState: .normal)
                barView.moreButton.theme_setImage("images.new_morewhite_titlebar", forState: .normal)
            }
        }
    }
}
