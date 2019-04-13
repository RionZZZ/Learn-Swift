//
//  UserDiggCell.swift
//  News
//
//  Created by Rion on 2019/4/13.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class UserDiggCell: UITableViewCell, RegisterCellFromNib {
    
    @IBOutlet weak var avatarImage: AnimatableImageView!
    @IBOutlet weak var vipImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var user = DongtaiUserDigg() {
        didSet {
            avatarImage.kf.setImage(with: URL(string: user.avatar_url))
            vipImage.isHidden = !user.user_verified
            nameLabel.text = user.screen_name
            descLabel.text = user.verified_reason
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
