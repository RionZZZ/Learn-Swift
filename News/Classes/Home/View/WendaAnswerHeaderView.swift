//
//  WendaAnswerHeaderView.swift
//  News
//
//  Created by Rion on 2019/4/16.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import Kingfisher

class WendaAnswerHeaderView: UIView, NibLoadable {

    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var answerCount: UILabel!
    @IBOutlet weak var collectionCount: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var unfoldButton: UIButton!
    @IBOutlet weak var unfoldButtonWidth: NSLayoutConstraint!
    
    var question = WendaQuestion() {
        didSet {
            titleLabel.text = question.title
            titleLabelHeight.constant = question.titleH!
            contentLabel.text = question.content.text
//            contentLabelHeight.constant = 20
            answerCount.text = question.answerCount + "个回答 · "
            collectionCount.text = question.followCount + "个收藏"
            if question.content.thumb_image_list.count != 0 {
                let thumb = question.content.thumb_image_list.first!
                imageView.kf.setImage(with: URL(string: (thumb.uri)))
                imageViewWidth.constant = 166
                imageViewHeight.constant = 166 * thumb.ratio
            }
            height = question.foldHeight!
            layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func onUnfoldClick(_ sender: UIButton) {
        sender.isHidden = true
        unfoldButtonWidth.constant = 0
        contentLabelHeight.constant = question.content.textH!
        height = question.foldHeight!
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}
