//
//  UILabel.swift
//  News
//
//  Created by Rion on 2019/4/18.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import CoreText

extension UILabel {
    //设置问答的内容
    func setSeparatedLinesFrom(_ attributedString: NSMutableAttributedString, _ hasImage: Bool) {
        //通过coreText创建字体
        let ctFont = CTFontCreateWithName(font!.fontName as CFString, font.pointSize, nil)
        //段落样式
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        //为富文本添加属性
        attributedString.addAttributes([kCTFontAttributeName as NSAttributedString.Key: ctFont, NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedString.length))
        //通过CcoreText创建frameSetter
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        //创建路径
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
        //通过CcoreText创建frame
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: attributedString.length), path, nil)
        //获取当前frame中，每一行的内容
        let lines: NSArray = CTFrameGetLines(frame)
        let attributedStrings = NSMutableAttributedString()
        
        for (index, line) in lines.enumerated() {
            //将line转成CTLine
            //获取每一行的视图
            let lineRange = CTLineGetStringRange(line as! CTLine)
            //将lineRange转成NSRange
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            //当前内容
            let currentAttributedString = NSMutableAttributedString(attributedString: attributedString.attributedSubstring(from: range))
            //有图片显示4行，否则6行
            if hasImage {
                if index == 3 && currentAttributedString.length >= 18 {
                    replaceContent(currentAttributedString)
                }
            } else {
                if index == 5 && currentAttributedString.length >= 18 {
                    replaceContent(currentAttributedString)
                }
            }
            
            attributedStrings.append(currentAttributedString)
        }
        
        attributedText = attributedStrings
        
    }
    
    private func replaceContent(_ currentAttributedString: NSMutableAttributedString) {
        let nsRange = NSRange(location: currentAttributedString.length - 8, length: 8)
        currentAttributedString.replaceCharacters(in: nsRange, with: NSAttributedString(string: "...全文\n", attributes: [.foregroundColor:UIColor.blueFontColor()]))
    }
}
