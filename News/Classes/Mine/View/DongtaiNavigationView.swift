//
//  DongtaiNavigationView.swift
//  News
//
//  Created by Rion on 2019/4/8.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class DongtaiNavigationView: UIView, NibLoadable {

    @IBOutlet weak var avatarButton: AnimatableButton!
    @IBOutlet weak var vipImage: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var user = DongtaiUser() {
        didSet {
            avatarButton.kf.setImage(with: URL(string: user.avatar_url), for: .normal)
            nameButton.setTitle(user.screen_name, for: .normal)
            followersButton.setTitle(user.followersCount, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //控件的固有属性大小
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    @IBAction func onAvatarClick(_ sender: UIButton) {
        
    }
    
    

}
