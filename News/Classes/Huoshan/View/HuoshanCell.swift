//
//  HuoshanCell.swift
//  News
//
//  Created by Rion on 2019/4/19.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import Kingfisher

class HuoshanCell: UICollectionViewCell, RegisterCellFromNib {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playCountButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var diggLabel: UILabel!
    
    var smallVideo = NewsModel() {
        didSet {
            titleLabel.attributedText = smallVideo.raw_data.attrbutedText
            if smallVideo.raw_data.large_image_list.count != 0 {
                imageView.kf.setImage(with: URL(string: smallVideo.raw_data.large_image_list.first!.urlString))
            } else if smallVideo.raw_data.first_frame_image_list.count != 0 {
                imageView.kf.setImage(with: URL(string: smallVideo.raw_data.first_frame_image_list.first!.urlString))
            }
            diggLabel.text = smallVideo.raw_data.action.diggCount + "赞"
            playCountButton.setTitle(smallVideo.raw_data.action.playCount + "次播放", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    @IBAction func onCloseClick(_ sender: UIButton) {
    }
    
}
