//
//  NavigationBarView.swift
//  News
//
//  Created by Rion on 2019/2/21.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable

class NavigationBarView: UIView, NibLoadable {

    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var concernButton: AnimatableButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var goBackClick: (() -> ())?
    var userDetail: UserDetail? {
        didSet {
            titleLabel.text = userDetail!.screen_name
            concernButton.isSelected = userDetail!.is_following
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backButton.theme_setImage("images.personal_home_back_white", forState: .normal)
        moreButton.theme_setImage("images.new_morewhite_titlebar", forState: .normal)
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        height = navigationBar.frame.maxY
    }
    
    @IBAction func BackButtonClick(_ sender: UIButton) {
        goBackClick?()
    }
    
    @IBAction func moreButtonClick(_ sender: UIButton) {
    }
    
    @IBAction func ConcernButtonClick(_ sender: AnimatableButton) {
        if sender.isSelected {
            //已经关注，要取消关注
            Network.relationUnfollow(user_id: userDetail!.user_id) { (_) in
                sender.isSelected = !sender.isSelected
            }
        } else {
            //还未关注，要关注
            Network.relationFollow(user_id: userDetail!.user_id) { (_) in
                sender.isSelected = !sender.isSelected
            }
        }
    }
}
