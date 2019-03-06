//
//  PostVideoOrArticleView.swift
//  News
//
//  Created by Rion on 2019/2/26.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import Kingfisher

class PostVideoOrArticleView: UIView, NibLoadable {

    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var title: UILabel!
    
    var group = DongtaiOriginGroup() {
        didSet {
            iconButton.kf.setBackgroundImage(with: URL(string: group.thumb_url), for: .normal)
            title.text = group.title
            switch group.media_type {
            case .postArticle:
                iconButton.setImage(nil, for: .normal)
            case .postVideo:
                iconButton.setImage(UIImage(named: "smallvideo_all_32x32_"), for: .normal)
            
            }
        }
    }
    
    var originGroup = DongtaiOriginGroup() {
        didSet {
            iconButton.kf.setBackgroundImage(with: URL(string: originGroup.thumb_url), for: .normal)
            title.text = originGroup.source + ": " + originGroup.title
            switch group.media_type {
            case .postArticle:
                iconButton.setImage(nil, for: .normal)
            case .postVideo:
                iconButton.setImage(UIImage(named: "smallvideo_all_32x32_"), for: .normal)
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func coverButtonClick(_ sender: UIButton) {
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        width = screenWidth - 30
    }
    
    
}
