//
//  OfflineDownloadCell.swift
//  News
//
//  Created by Rion on 2019/2/18.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class OfflineDownloadCell: UITableViewCell, RegisterCellOrNib {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
