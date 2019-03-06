//
//  Emoji.swift
//  News
//
//  Created by Rion on 2019/3/6.
//  Copyright © 2019年 Rion. All rights reserved.
//

import Foundation
import HandyJSON

struct Emoji: HandyJSON {
    var id = ""
    var name = ""
    var png = ""
}

struct EmojiManager {
    
    var emojis = [Emoji]()
    
    init() {
        //获取emoji的路径
        let path = Bundle.main.path(forResource: "emojis.plist", ofType: nil)
        //根据文件读取数据
        let arr = NSArray(contentsOfFile: path!) as! [[String: String]]
        //字典转模型
        emojis = arr.compactMap {
            Emoji.deserialize(from: $0 as NSDictionary)
        }
    }
    
    func emojiShow(content: String, font: UIFont) -> NSMutableAttributedString {
        
        let attributed = NSMutableAttributedString(string: content)
        let emojiPattern = "\\[.*?\\]" //emoji正则表达式
        let regex = try! NSRegularExpression(pattern: emojiPattern, options: [])
        let results = regex.matches(in: content, options: [], range: NSRange(location: 0, length: attributed.length))
        if results.count != 0 {
            //倒序遍历
            for index in stride(from: results.count - 1, through: 0, by: -1) {
                //取出结果的范围
                let result = results[index]
                //取出emoji的名字
                let emojiName = (content as NSString).substring(with: result.range)
                let attachment = NSTextAttachment()
                //取出对应的emoji模型
                let emoji = emojis.filter({
                    $0.name == emojiName
                }).first!
                //设置图片
                attachment.image = UIImage(named: emoji.png)
                attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
                //将图片替换为文字
                let imageString = NSAttributedString(attachment: attachment)
                attributed.replaceCharacters(in: result.range, with: imageString)
            }
        }
        
        return attributed
    }
    
}
