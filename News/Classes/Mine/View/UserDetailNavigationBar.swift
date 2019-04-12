//
//  userDetailNavigationBar.swift
//  News
//
//  Created by 杨蒙 on 2017/12/25.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit
import IBAnimatable

class UserDetailNavigationBar: UIView, NibLoadable {
    
    var goBackClick: (() -> ())?
    var userDetail = UserDetail() {
        didSet {
            nameLabel.text = userDetail.screen_name
            concernButton.isSelected = userDetail.is_following
        }
    }
    
    /// 标题
    @IBOutlet weak var nameLabel: UILabel!
    /// 关注按钮
    @IBOutlet weak var concernButton: AnimatableButton!
    /// 导航栏
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var navigationBarTop: NSLayoutConstraint!
    /// 返回按钮
    @IBOutlet weak var returnButton: UIButton!
    /// 更多按钮
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        returnButton.theme_setImage("images.personal_home_back_white", forState: .normal)
        moreButton.theme_setImage("images.new_morewhite_titlebar", forState: .normal)
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        navigationBar.width = screenWidth
        frame = CGRect(x: 0, y: 0, width: screenWidth, height: 44)
        moreButton.x = screenWidth - 35
    }
    
    @IBAction func onBackClick(_ sender: Any) {
        goBackClick?()
    }
    
}

// MARK: - 按钮点击事件
extension UserDetailNavigationBar {
    
    /// 接收到了关注按钮的点击
    @objc private func receivedConcernButtonClicked(notification: Notification) {
        let userInfo = notification.userInfo as! [String: Any]
        let isSelected = userInfo["isSelected"] as! Bool
        concernButton.isSelected = isSelected
    }
    
    /// 关注按钮点击
    @IBAction func concernButtonClicked(_ sender: AnimatableButton) {
        if sender.isSelected {
            //已经关注，要取消关注
            Network.relationUnfollow(user_id: userDetail.user_id) { (_) in
                sender.isSelected = !sender.isSelected
            }
        } else {
            //还未关注，要关注
            Network.relationFollow(user_id: userDetail.user_id) { (_) in
                sender.isSelected = !sender.isSelected
            }
        }
    }
}
