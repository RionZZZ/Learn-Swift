//
//  UserDetailWendaCell.swift
//  News
//
//  Created by Rion on 2019/3/12.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class UserDetailWendaCell: UITableViewCell, RegisterCellFromNib {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var diggCountLabel: UILabel!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var wenda = UserDetailWenda() {
        didSet {
            titleLabel.text = wenda.question.title
            contentLabel.text = wenda.answer.content_abstract.text
            diggCountLabel.text = wenda.answer.diggCount + "赞 ·"
            readCountLabel.text = wenda.answer.browCount + "人阅读"
            timeLabel.text = wenda.answer.show_time
            contentHeight.constant = wenda.answer.content_abstract.textHeight
            layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
