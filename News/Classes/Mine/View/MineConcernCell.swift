//
//  MineConcernCell.swift
//  News
//
//  Created by Rion on 2019/2/16.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import Kingfisher

class MineConcernCell: UICollectionViewCell, RegisterCellOrNib {
    
    @IBOutlet weak var avatorImage: UIImageView!
    @IBOutlet weak var vip: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipsButton: UIButton!
    
    
    var mineConcern : MineConcernModel? {
        didSet {
            avatorImage.kf.setImage(with: URL(string: (mineConcern?.icon)!))
            nameLabel.text = mineConcern?.name
            if let isVip = mineConcern?.is_verify {
                vip.isHidden = !isVip
            }
            if let hasTip = mineConcern?.tips {
                tipsButton.isHidden = !hasTip
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tipsButton.layer.borderWidth = 1
        tipsButton.layer.borderColor = UIColor.white.cgColor
    }

}
