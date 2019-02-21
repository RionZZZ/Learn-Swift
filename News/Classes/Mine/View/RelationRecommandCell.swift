//
//  RelationRecommandCell.swift
//  News
//
//  Created by Rion on 2019/2/21.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class RelationRecommandCell: UICollectionViewCell, RegisterCellOrNib {

    @IBOutlet weak var avatarImage: AnimatableImageView!
    @IBOutlet weak var vip: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var concernButton: AnimatableButton!
    @IBOutlet weak var loadImage: UIImageView!
    
    var userCard: UserCard? {
        didSet {
            nameLabel.text = userCard!.user.info.name
            avatarImage.kf.setImage(with: URL(string: userCard!.user.info.avatar_url)!)
            vip.isHidden = userCard!.user.info.user_auth_info == ""
            reasonLabel.text = userCard!.recommend_reason
        }
    }
    
    private lazy var animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi
        animation.duration = 0.5
        animation.autoreverses = false
        animation.repeatCount = MAXFLOAT
        return animation
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func concernButtonClick(_ sender: AnimatableButton) {
        loadImage.isHidden = false
        loadImage.layer.add(animation, forKey: nil)
        if sender.isSelected {
            //已经关注，要取消关注
            Network.relationUnfollow(user_id: userCard!.user.info.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.loadImage.layer.removeAllAnimations()
                self.loadImage.isHidden = true
            }
        } else {
            //还未关注，要关注
            Network.relationFollow(user_id: userCard!.user.info.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.loadImage.layer.removeAllAnimations()
                self.loadImage.isHidden = true
                
            }
        }
    }

}
