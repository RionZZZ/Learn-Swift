//
//  SmallVideoCell.swift
//  News
//
//  Created by Rion on 2019/4/19.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class SmallVideoCell: UICollectionViewCell, RegisterCellFromNib {
    
    @IBOutlet weak var avatarButton: AnimatableButton!
    @IBOutlet weak var vImageView: UIImageView!
    @IBOutlet weak var nameButton: AnimatableButton!
    @IBOutlet weak var concernButton: AnimatableButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    
    var smallVideo = NewsModel() {
        didSet {
            nameButton.setTitle(smallVideo.raw_data.user.info.name, for: .normal)
            avatarButton.kf.setImage(with: URL(string: smallVideo.raw_data.user.info.avatar_url), for: .normal)
            vImageView.isHidden = !smallVideo.raw_data.user.info.user_verified
            concernButton.isSelected = smallVideo.raw_data.user.relation.is_following
            titleLabel.attributedText = smallVideo.raw_data.attrbutedText
            
            if smallVideo.raw_data.large_image_list.count != 0 {
                bgImageView.kf.setImage(with: URL(string: smallVideo.raw_data.large_image_list.first!.urlString))
            } else if smallVideo.raw_data.first_frame_image_list.count != 0 {
                bgImageView.kf.setImage(with: URL(string: smallVideo.raw_data.first_frame_image_list.first!.urlString))
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func onAvatarClick(_ sender: AnimatableButton) {
    }
    
    @IBAction func onConcernClick(_ sender: AnimatableButton) {
    }
    
}
