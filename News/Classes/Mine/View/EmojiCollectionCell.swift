
//
//  EmojiCOllectionCell.swift
//  News
//
//  Created by Rion on 2019/4/13.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class EmojiCollectionCell: UICollectionViewCell, RegisterCellFromNib {
    
    @IBOutlet weak var emojiButton: UIButton!
    
    var emoji  = Emoji() {
        didSet {
            if emoji.isDelete {
                emojiButton.setImage(UIImage(named: "input_emoji_delete_44x44_"), for: .normal)
            } else if emoji.isEmpty {
                emojiButton.setImage(nil, for: .normal)
            } else {
                emojiButton.setImage(UIImage(named: emoji.png), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
