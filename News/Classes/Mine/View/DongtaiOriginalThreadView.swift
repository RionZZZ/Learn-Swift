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

    var originThread: DongtaiOriginThread? {
        didSet {
            contentLabel.text = originThread!.content
            contentLabelHeight.constant = originThread!.contentH
            collectionView.thumbImageList = originThread!.thumb_image_list
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
