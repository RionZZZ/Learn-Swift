//
//  DongtaiCollectionCell.swift
//  News
//
//  Created by Rion on 2019/2/26.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

class DongtaiCollectionCell: UICollectionViewCell, RegisterCellFromNib {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var iconButton: UIButton!
    
    var isPostVideo = false {
        didSet {
            iconButton.setImage(isPostVideo ? UIImage(named: "smallvideo_all_32x32_") : nil, for: .normal)
        }
    }
    
    var thumbImage: ThumbImage? {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: thumbImage!.url as String))
        }
    }
    var largeImage = LargeImage() {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: largeImage.url as String), placeholder: nil, options: nil, progressBlock: { (received, total) in
                let progress = Float(received) / Float(total)
                SVProgressHUD.showProgress(progress)
                SVProgressHUD.setBackgroundColor(.clear)
                SVProgressHUD.setForegroundColor(.white)
            }) { result in
                SVProgressHUD.dismiss()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
