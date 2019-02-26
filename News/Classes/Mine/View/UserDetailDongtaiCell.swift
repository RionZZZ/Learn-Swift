//
//  UserDetailDongtaiCell.swift
//  News
//
//  Created by Rion on 2019/2/25.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class UserDetailDongtaiCell: UITableViewCell, RegisterCellOrNib {
    
    @IBOutlet weak var avatarImage: AnimatableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var modifyTimeLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var dongtai: UserDetailDongtai? {
        didSet {
            avatarImage.kf.setImage(with: URL(string: dongtai!.user.avatar_url))
            nameLabel.text = dongtai!.user.screen_name
            modifyTimeLabel.text = "· \(dongtai!.create_time)"
            likeButton.setTitle("\(dongtai!.comment_count)", for: .normal)
            forwardButton.setTitle("\(dongtai!.forward_count)", for: .normal)
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.theme_textColor = "colors.black"
        likeButton.theme_setTitleColor("colors.black", forState: .normal)
        forwardButton.theme_setTitleColor("colors.black", forState: .normal)
        commentButton.theme_setTitleColor("colors.black", forState: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
