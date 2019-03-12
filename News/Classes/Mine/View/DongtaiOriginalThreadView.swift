//
//  DongtaiOriginalThreadView.swift
//  News
//
//  Created by Rion on 2019/3/2.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class DongtaiOriginalThreadView: UIView, NibLoadable {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: DongtaiCollectionView!

    let emojiManager = EmojiManager()
    var originThread: DongtaiOriginThread? {
        didSet {
            //            contentLabel.text = originThread!.content
            let mutableAttrbuted = NSMutableAttributedString(string: "@\(originThread!.user.screen_name)", attributes: [.foregroundColor: UIColor.blueFontColor()])
            mutableAttrbuted.append(emojiManager.emojiShow(content: originThread!.content, font: contentLabel.font))
            contentLabel.attributedText = mutableAttrbuted
            contentLabelHeight.constant = originThread!.contentH
            collectionView.thumbImageList = originThread!.thumb_image_list
            collectionView.largeImages = originThread!.large_image_list
            layoutIfNeeded()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        height = originThread!.height
        width = screenWidth
    }

}
