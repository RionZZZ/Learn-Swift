//
//  UITextView.swift
//  News
//
//  Created by Rion on 2019/4/16.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

extension UITextView {
    
    //设置textview富文本内容
    func setAttributedText(emoji: Emoji) {
        if emoji.isEmpty {
            return
        }
        if emoji.isDelete {
            deleteBackward()
            return
        }
        
        //创建附件
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: emoji.png)
        //当前字体大小
        let currentFont = font!
        //附件的大小
        attachment.bounds = CGRect(x: 0, y: -4, width: currentFont.lineHeight, height: currentFont.lineHeight)
        let imageString = NSAttributedString(attachment: attachment)
        //获取当前光标位置
        let range = selectedRange
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        mutableAttributedText.replaceCharacters(in: range, with: imageString)
        attributedText = mutableAttributedText
        
        //重置字体大小
        font = currentFont
        //光标+1
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
