//
//  UserDetailHeaderView.swift
//  News
//
//  Created by Rion on 2019/2/19.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class UserDetailHeaderView: UIView {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundTop: NSLayoutConstraint!
    @IBOutlet weak var avatorImage: AnimatableImageView!
    @IBOutlet weak var vipImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var toutiaoImage: UIImageView!
    @IBOutlet weak var sendMail: UIButton!
    @IBOutlet weak var concernButton: AnimatableButton!
    @IBOutlet weak var recommandButton: AnimatableButton!
    @IBOutlet weak var recommandWidth: NSLayoutConstraint!
    @IBOutlet weak var recommandTrailing: NSLayoutConstraint!
    @IBOutlet weak var recommandView: UIView!
    @IBOutlet weak var recommandViewHeight: NSLayoutConstraint!
    @IBOutlet weak var verifiedAgencyLabel: UILabel!
    @IBOutlet weak var verifiedAgencyLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var verifiedAgencyLabelTop: NSLayoutConstraint!
    @IBOutlet weak var verifiedContentLabel: UILabel!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var areaButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var areaButtonTop: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var unfoldButton: UIButton!
    @IBOutlet weak var unfoldButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var unfoldButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var followingsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var topTabView: UIView!
    @IBOutlet weak var topTabHeight: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var baseView: UIView!
//    @IBOutlet weak var bottomScrollView: UIScrollView!
    
    var userDetail: UserDetail? {
        didSet {
            backgroundImage.kf.setImage(with: URL(string: userDetail!.bg_img_url))
            avatorImage.kf.setImage(with: URL(string: userDetail!.avatar_url))
            vipImage.isHidden = !userDetail!.user_verified
            nameLabel.text = userDetail!.screen_name
            if userDetail!.verified_agency == "" {
                verifiedAgencyLabelHeight.constant = 0
                verifiedAgencyLabelTop.constant = 0
            } else {
                verifiedAgencyLabel.text = userDetail!.verified_agency + "："
                verifiedContentLabel.text = userDetail!.verified_content
            }
            concernButton.isSelected = userDetail!.is_following
            if userDetail!.area == "" {
                areaButton.isHidden = true
                areaButtonHeight.constant = 0
                areaButtonTop.constant = 0
            } else {
                areaButton.setTitle(userDetail!.area, for: .normal)
            }
            descriptionLabel.text = userDetail!.description as String
            if userDetail!.descriptionHeight! > 21 {
                unfoldButton.isHidden = false
                unfoldButtonWidth.constant = 40
            }
            recommandWidth.constant = 0
            recommandTrailing.constant = 10
            followersCountLabel.text = userDetail!.followersCount
            followingsCountLabel.text = userDetail!.followingsCount
            layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func headerView() -> UserDetailHeaderView {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! UserDetailHeaderView
    }
    
    @IBAction func sendMailClick(_ sender: UIButton) {
    }
    
    @IBAction func concernButtonClick(_ sender: AnimatableButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            //已经关注，要取消关注
            Network.relationUnfollow(user_id: userDetail!.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.recommandButton.isHidden = true
                self.recommandWidth.constant = 0
                self.recommandButton.isSelected = false
                self.recommandTrailing.constant = 0
                self.recommandViewHeight.constant = 0
                UIView.animate(withDuration: 0.25, animations: {
                    self.recommandButton.imageView?.transform = .identity
                    self.layoutIfNeeded()
                }, completion: { (_) in
                    self.resetLayout()
                })
            }
        } else {
            //还未关注，要关注
            Network.relationFollow(user_id: userDetail!.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.recommandButton.isHidden = false
                self.recommandWidth.constant = 28
                self.recommandButton.isSelected = false
                self.recommandTrailing.constant = 15
                self.recommandViewHeight.constant = 230
                UIView.animate(withDuration: 0.25, animations: {
                    self.layoutIfNeeded()
                }, completion: { (_) in
                    self.resetLayout()
                    Network.loadRelationUserRecommand(user_id: self.userDetail!.user_id, completionHandler: { (UserCard) in
                        
                    })
                })
            }
        }
    }
    
    @IBAction func recommandButtonClick(_ sender: AnimatableButton) {
        sender.isSelected = !sender.isSelected
        recommandViewHeight.constant = sender.isSelected ? 0 : 230
        UIView.animate(withDuration: 0.25, animations: {
            sender.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(sender.isSelected ? Double.pi : 0))
            self.layoutIfNeeded()
        }) { (_) in
            self.resetLayout()
        }
    }
    
    @IBAction func unflodButtonClick(_ sender: UIButton) {
        unfoldButton.isHidden = true
        unfoldButtonWidth.constant = 0
        descriptionLabelHeight.constant = userDetail!.descriptionHeight!
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            self.resetLayout()
        }
    }
    
    private func resetLayout() {
        baseView.height = topTabView.frame.maxY
        height = baseView.frame.maxY
    }
    
    
}
