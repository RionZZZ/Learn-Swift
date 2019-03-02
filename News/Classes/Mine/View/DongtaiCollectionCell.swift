//
//  DongtaiCollectionCell.swift
//  News
//
//  Created by Rion on 2019/2/26.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import Kingfisher

class DongtaiCollectionCell: UICollectionViewCell, RegisterCellOrNib {

    @IBOutlet weak var thumbImageView: UIImageView!
    
    var thumbImage: ThumbImage? {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: thumbImage!.url as String))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
