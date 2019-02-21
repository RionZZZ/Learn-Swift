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

class UserDetailHeaderView: UIView, NibLoadable {

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
    
    var previousButton = UIButton()
    lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: (topTabButtonWidth - topTabindicatorWidth) * 0.5, y: topTabView.height - 2, width: topTabindicatorWidth, height: topTabindicatorHeight))
        indicatorView.theme_backgroundColor = "colors.globalRedColor"
        return indicatorView
    }()
    
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
            recommandTrailing.constant = 15
            followersCountLabel.text = userDetail!.followersCount
            followingsCountLabel.text = userDetail!.followingsCount
            if userDetail!.top_tab.count > 0 {
                //添加按钮
                for (index, value) in userDetail!.top_tab.enumerated() {
                    let button = UIButton(frame: CGRect(x: CGFloat(index) * topTabButtonWidth, y: 0, width: topTabButtonWidth, height: scrollView.height))
                    button.setTitle(value.show_name, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                    button.theme_setTitleColor("colors.black", forState: .normal)
                    button.theme_setTitleColor("colors.globalRedColor", forState: .selected)
                    button.addTarget(self, action: #selector(topTabButtonClick), for: .touchUpInside)
                    scrollView.addSubview(button)
                    if index == 0 {
                        button.isSelected = true
                        previousButton = button
                    }
                    if index == userDetail!.top_tab.count - 1 {
                        scrollView.contentSize = CGSize(width: button.frame.maxX, height: scrollView.height)
                    }
                }
                scrollView.addSubview(indicatorView)
            } else {
                topTabHeight.constant = 0
                topTabView.isHidden = true
            }
            layoutIfNeeded()
        }
    }
    
    //推荐列表
    lazy var relationRecommand: RelationRecommandView = {
        let relationRecommand = RelationRecommandView.loadViewFromNib()
        return relationRecommand
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
    }
    
//    class func headerView() -> UserDetailHeaderView {
//        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! UserDetailHeaderView
//    }
    
    @IBAction func sendMailClick(_ sender: UIButton) {
    }
    
    @IBAction func concernButtonClick(_ sender: AnimatableButton) {
        if sender.isSelected {
            //已经关注，要取消关注
            Network.relationUnfollow(user_id: userDetail!.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.recommandButton.isHidden = true
                self.recommandWidth.constant = 0
                self.recommandButton.isSelected = false
//                self.recommandTrailing.constant = 0
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
//                self.recommandTrailing.constant = 15
                self.recommandViewHeight.constant = 230
                UIView.animate(withDuration: 0.25, animations: {
                    self.layoutIfNeeded()
                }, completion: { (_) in
                    self.resetLayout()
                    Network.loadRelationUserRecommand(user_id: self.userDetail!.user_id, completionHandler: { (userCards) in
                        self.recommandView.addSubview(self.relationRecommand)
                        self.relationRecommand.userCards = userCards
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
    
    @objc func topTabButtonClick(button: UIButton) {
        previousButton.isSelected = false
        button.isSelected = !button.isSelected
        UIView.animate(withDuration: 0.25, animations: {
            self.indicatorView.centerX = button.centerX
        }) { (_) in
            self.previousButton = button
        }
    }
    
}
