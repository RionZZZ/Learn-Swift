//
//  WendaCell.swift
//  News
//
//  Created by Rion on 2019/4/16.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class WendaAnswerCell: UITableViewCell, RegisterCellFromNib {
    
    var answer = WendaAnswer() {
        didSet {
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
