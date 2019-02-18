//
//  SettingCell.swift
//  News
//
//  Created by Rion on 2019/2/18.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell, RegisterCellOrNib {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var subtitleHeight: NSLayoutConstraint!
    
    var setting: SettingModel? {
        didSet {
            titleLabel.text = setting!.title
            subtitleLabel.text = setting!.subtitle
            rightLabel.text = setting!.rightLabel
            arrowImage.isHidden = setting!.isHiddenArrow
            switchView.isHidden = setting!.isHiddenSwitch
            if !setting!.isHiddenSubtitle {
                subtitleHeight.constant = 20
                layoutIfNeeded()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        theme_backgroundColor = "colors.cellBackgroundColor"
        titleLabel.theme_textColor = "colors.black"
        rightLabel.theme_textColor = "colors.cellRightTextColor"
        arrowImage.theme_image = "images.cellArrow"
        separator.theme_backgroundColor = "colors.separatorColor"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
