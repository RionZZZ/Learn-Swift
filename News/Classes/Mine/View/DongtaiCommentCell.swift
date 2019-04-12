//
//  DongtaiCommentCell.swift
//  News
//
//  Created by Rion on 2019/4/11.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable

class DongtaiCommentCell: UITableViewCell, RegisterCellFromNib {
    
    @IBOutlet weak var avatarImage: AnimatableButton!
    @IBOutlet weak var vipImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var zanButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var replyButton: AnimatableButton!
    
    var comment = DongtaiComment() {
        didSet {
            if comment.user_profile_image_url != "" {
                avatarImage.kf.setImage(with: URL(string: comment.user_profile_image_url), for: .normal)
                vipImage.isHidden = !comment.user_verified
                nameLabel.text = comment.user_name != "" ? comment.user_name : ""
                
                if comment.user_auth_info.auth_info != "" {
                    infoLabel.text = comment.user_auth_info.auth_info
                }
            } else if comment.user.avatar_url != "" {
                avatarImage.kf.setImage(with: URL(string: comment.user.avatar_url), for: .normal)
                vipImage.isHidden = !comment.user.user_verified
                nameLabel.text = comment.user.screen_name
                
                if comment.user.user_auth_info.auth_info != "" {
                    infoLabel.text = comment.user.user_auth_info.auth_info
                }
            }
            
            timeLabel.text = comment.createTime
            if comment.reply_count != 0 {
                replyButton.setTitle("\(comment.reply_count)回复", for: .normal)
            }
            replyButton.setTitle(comment.reply_count == 0 ? "回复" : "\(comment.reply_count)回复", for: .normal)
            zanButton.setTitle(comment.digg_count == 0 ? "赞" : comment.diggCount, for: .normal)
            zanButton.isSelected = comment.user_digg
//            contentLabel.text = comment.text
            contentLabel.attributedText = comment.attributedContent
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onZanClick(_ sender: UIButton) {
    }
    
    @IBAction func onReplyClick(_ sender: AnimatableButton) {
    }
    
}
