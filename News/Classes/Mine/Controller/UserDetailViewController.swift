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
//        scrollView.addSubview(headerView)
        view.addSubview(barView)
        //返回方法
        barView.goBackClick = { [weak self] in
            self!.navigationController?.popViewController(animated: true)
        }
//        scrollView.contentSize = CGSize(width: screenWidth, height: 1000)
        bottomViewBottom.constant = isBigPhone ? safeAreaBottom! : 0
        view.layoutIfNeeded()
        
        //用户详情数据
        Network.loadUserDetail(user_id: userId) { (userDetail) in
            //用户动态列表
            Network.loadUserDetailDongtai(user_id: self.userId, completionHandler: { (dongtais) in
                self.headerView.dongtais = dongtais
                
                self.scrollView.addSubview(self.headerView)
                self.userDetail = userDetail
                self.headerView.userDetail = userDetail
                self.barView.userDetail = userDetail
                if userDetail.bottom_tab.count == 0 {
                    self.headerView.height = 969 - 44
                    self.bottomViewBottom.constant = 0
                    self.view.layoutIfNeeded()
                } else {
                    self.headerView.height = 969
                    self.bottomView.addSubview(self.footerView)
                    self.footerView.bottomTabs = userDetail.bottom_tab
                }
                self.scrollView.contentSize = CGSize(width: screenWidth, height: self.headerView.height)
            })
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
            //直接跳转
            bottomPushVC.url = bottomTab.value
            self.navigationController?.pushViewController(bottomPushVC, animated: true)
        } else {
            //弹出子视图
            let storyboard = UIStoryboard(name: "\(UserDetailBottomPopController.self)", bundle: nil)
            let popVC = storyboard.instantiateViewController(withIdentifier: "\(UserDetailBottomPopController.self)") as! UserDetailBottomPopController
            popVC.tabChildren = bottomTab.children
            popVC.modalPresentationStyle = .custom
            popVC.didSelectedChild = { [weak self] in
                bottomPushVC.url = $0.value
                self!.navigationController?.pushViewController(bottomPushVC, animated: true)
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
//        print(offsetY)
        if offsetY < -statusBarHeight {
            //图片拉伸，粘住顶部
            let totalOffset = UserDetailHeaderBGHeight + abs(offsetY)
            let f = totalOffset / UserDetailHeaderBGHeight
            headerView.backgroundImage.frame = CGRect(x: -screenWidth * (f - 1), y: offsetY, width: screenWidth * f, height: totalOffset)
            barView.backgroundColor = UIColor(white: 1, alpha: 0)
        } else if offsetY == 0 {
            for subview in headerView.bottomScrollView.subviews {
                let tableview = subview as! UITableView
                tableview.isScrollEnabled = false
            }
        } else {
            var alpha = (offsetY + statusBarHeight) / (146 - 88)
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
            
            //14 --> 导航栏距离图片底部
            //15 --> 关注按钮距离导航栏底部
            //14 --> 关注按钮高度的一半
            var concernAlpha = offsetY / (14 + 15 + 28)
            if offsetY >= 43 {
                concernAlpha = min(concernAlpha, 1)
                barView.titleLabel.isHidden = false
                barView.concernButton.isHidden = false
                barView.titleLabel.textColor = UIColor(r: 0, g: 0, b: 0, alpha: concernAlpha)
                barView.concernButton.alpha = concernAlpha
            } else {
                concernAlpha = min(0, concernAlpha)
                barView.titleLabel.textColor = UIColor(r: 0, g: 0, b: 0, alpha: concernAlpha)
                barView.concernButton.alpha = concernAlpha
            }
            
            //设置headerview的topTabView黏住顶部
            if offsetY >= (14 + headerView.topTabView.frame.minY) {//14 + 201
                headerView.y = offsetY - (14 + headerView.topTabView.frame.minY)
                for subview in headerView.bottomScrollView.subviews {
                    let tableview = subview as! UITableView
                    tableview.isScrollEnabled = true
                }
            } else {
                headerView.y = 0
            }
            
        }
    }
}
