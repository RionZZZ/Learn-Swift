//
//  WendaCell.swift
//  News
//
//  Created by Rion on 2019/4/16.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class WendaAnswerCell: UITableViewCell, RegisterCellFromNib {
    
    @IBOutlet weak var avatarImageView: AnimatableImageView!
    @IBOutlet weak var vImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIntroLabel: UILabel!
    @IBOutlet weak var userintroLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var concernButton: UIButton!
    @IBOutlet weak var diggLabel: UILabel!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var thumbImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var thumbImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    
    var answer = WendaAnswer() {
        didSet {
            nameLabel.text = answer.user.uname
            avatarImageView.kf.setImage(with: URL(string: answer.user.avatar_url))
            vImageView.isHidden = !answer.user.is_verify
            concernButton.isSelected = answer.user.is_following
            if answer.user.user_intro != "" {
                userIntroLabel.text = answer.user.user_intro
                userintroLabelHeight.constant = 16
            }
            diggLabel.text = answer.diggCount + "赞 · "
            readCountLabel.text = answer.browCount + "阅读"
            
            thumbImageView.image = nil
            
            if answer.content_abstract.hasImage {
                let thumb = answer.content_abstract.thumb_image_list.first!
                //tablecell重用机制和kf异步加载图片，缓存池重用导致数据错乱
                thumbImageView.kf.setImage(with: URL(string: thumb.urlString))
                thumbImageViewHeight.constant = 166
                thumbImageViewWidth.constant = 166 * thumb.ratio
            } else {
                thumbImageView.image = nil
                thumbImageViewHeight.constant = 0
            }
            contentLabel.setSeparatedLinesFrom(answer.attributedString, answer.content_abstract.hasImage)
            contentLabelHeight.constant = answer.content_abstract.textH!
            layoutIfNeeded()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onConcernClick(_ sender: UIButton) {
    
    }
    
    @IBAction func onCoverClick(_ sender: Any) {
    }
    
}
