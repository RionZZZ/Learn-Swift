//
//  UserDetailViewController2.swift
//  News
//
//  Created by Rion on 2019/4/11.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class UserDetailViewController2: UIViewController {

    @IBOutlet weak var tabview: UserDetailTableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    
    var userId: Int = 0
    var userDetail: UserDetail?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = barView
        
        tabview._registerCell(cell: UserDetailCell.self)
        tabview.tableFooterView = UIView()
        //用户详情数据
//        userId = 51025535398 //马未都
        userId = 8 //张一鸣
        Network.loadUserDetail(user_id: userId) { (userDetail) in
            //用户动态列表
            Network.loadUserDetailDongtai(user_id: self.userId, completionHandler: { (dongtais) in
                
                if userDetail.bottom_tab.count != 0 {
                    self.bottomViewHeight.constant = isBigPhone ? 78 : 44
                    self.view.layoutIfNeeded()
                    self.footerView.bottomTabs = userDetail.bottom_tab
                    self.bottomView.addSubview(self.footerView)
                }
                self.userDetail = userDetail
                self.headerView.userDetail = userDetail
                self.barView.userDetail = userDetail
                self.topTabView.topTabs = userDetail.top_tab
                self.tabview.tableHeaderView = self.headerView
                
                let navHeight = isBigPhone ? 88 : 64
                let rowHeight = screenHeight - CGFloat(navHeight) - self.tabview.sectionHeaderHeight - self.bottomViewHeight.constant
                self.tabview.rowHeight = rowHeight
                
                //要先reload，否则无法刷新数据，也不能设置行高
                self.tabview.reloadData()
                if userDetail.top_tab.count != 0 {
                    
                    let cell = self.tabview.cellForRow(at: IndexPath(row: 0, section: 0)) as! UserDetailCell
                    for (index, topTab) in userDetail.top_tab.enumerated() {
                        let dongtaiVC = DongtaiTableViewController()
                        self.addChild(dongtaiVC)
                        if index == 0 {
                            dongtaiVC.currentTopTabType = topTab.type
                        }
                        dongtaiVC.userId = userDetail.user_id
                        dongtaiVC.tableView.frame = CGRect(x: CGFloat(index) * screenWidth, y: 0, width: screenWidth, height: rowHeight)
                        cell.scrollView.addSubview(dongtaiVC.tableView)
                        if userDetail.top_tab.count - 1 == index {
                            cell.scrollView.contentSize = CGSize(width: CGFloat(userDetail.top_tab.count) * screenWidth, height: cell.scrollView.height)
                        }
                    }
                    
                }
            })
        }
        
        selectedAction()
    }
    
    //懒加载header
    fileprivate lazy var headerView: UserDetailHeaderView2 = {
        let headerView = UserDetailHeaderView2.loadViewFromNib()
        return headerView
    }()
    
    //懒加载footer
    fileprivate lazy var footerView: UserDetailBottomView = {
        let footerView = UserDetailBottomView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        footerView.delegate = self
        return footerView
    }()
    
    //懒加载bar
    fileprivate lazy var barView: UserDetailNavigationBar = {
        let barView = UserDetailNavigationBar.loadViewFromNib()
        return barView
    }()
    
    //懒加载topTab
    fileprivate lazy var topTabView: TopTabScrollView = {
        let topTabView = TopTabScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        return topTabView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_clear"), for: .default)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}

extension UserDetailViewController2: UserDetailBottomDelegate {
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
    
    //按钮点击
    private func selectedAction() {
        barView.goBackClick = { [weak self] in
            self!.navigationController?.popViewController(animated: true)
        }
        headerView.didSelectConcernButton = { [weak self] in
            self!.tabview.tableHeaderView = self!.headerView
        }
        //当前topTab类型
        topTabView.currentTopTab = { [weak self] (topTab, index) in
            let cell = self!.tabview.cellForRow(at: IndexPath(row: 0, section: 0)) as! UserDetailCell
            let dongtaiVC = self!.children[index] as! DongtaiTableViewController
            dongtaiVC.currentTopTabType = topTab.type
            cell.scrollView.setContentOffset(CGPoint(x: CGFloat(index) * screenWidth, y: 0), animated: true)
        }
    }
    
}

extension UserDetailViewController2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        view.addSubview(topTabView)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabview._dequeueReusableCell(indexPath: indexPath) as UserDetailCell
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < -statusBarHeight {
            let totalOffset = UserDetailHeaderBGHeight + abs(offsetY)
            let f = totalOffset / UserDetailHeaderBGHeight
            headerView.backgroundImage.frame = CGRect(x: -screenWidth * (f - 1), y: offsetY, width: screenWidth * f, height: totalOffset)
            barView.navigationBar.backgroundColor = UIColor(white: 1, alpha: 0)
        } else {
            var alpha = (offsetY + statusBarHeight) / (146 - 88)
            alpha = min(alpha, 1)
            barView.navigationBar.backgroundColor = UIColor(white: 1, alpha: alpha)
            if (alpha == 1) {
                //更换导航栏颜色
                navigationController?.navigationBar.barStyle = .default
                barView.returnButton.theme_setImage("images.personal_home_back_black", forState: .normal)
                barView.moreButton.theme_setImage("images.new_more_titlebar", forState: .normal)
            } else {
                navigationController?.navigationBar.barStyle = .black
                barView.returnButton.theme_setImage("images.personal_home_back_white", forState: .normal)
                barView.moreButton.theme_setImage("images.new_morewhite_titlebar", forState: .normal)
            }
            
            //14 --> 导航栏距离图片底部
            //15 --> 关注按钮距离导航栏底部
            //14 --> 关注按钮高度的一半
            var concernAlpha = offsetY / (14 + 15 + 28)
            if offsetY >= 43 {
                concernAlpha = min(concernAlpha, 1)
                barView.nameLabel.isHidden = false
                barView.concernButton.isHidden = false
                barView.nameLabel.textColor = UIColor(r: 0, g: 0, b: 0, alpha: concernAlpha)
                barView.concernButton.alpha = concernAlpha
            } else {
                concernAlpha = min(0, concernAlpha)
                barView.nameLabel.textColor = UIColor(r: 0, g: 0, b: 0, alpha: concernAlpha)
                barView.concernButton.alpha = concernAlpha
            }
        }
    }
}


class UserDetailTableView: UITableView, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let otherView = otherGestureRecognizer.view else {
            return false
        }
        if otherView.isMember(of: UIScrollView.self) {
            return false
        }
        let isPan = gestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
        if isPan && otherView.isKind(of: UIScrollView.self) {
            return true
        }
        return false
    }
}
