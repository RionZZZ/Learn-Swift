//
//  Emoji.swift
//  News
//
//  Created by Rion on 2019/3/6.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
//import HandyJSON

struct Emoji {
    var id = ""
    var name = ""
    var png = ""
    
    var isDelete = false
    var isEmpty = false
    
    init(id: String = "", name: String = "", png: String = "", isDelete: Bool = false, isEmpty: Bool = false) {
        self.id = id
        self.name = name
        self.png = png
        self.isDelete = isDelete
        self.isEmpty = isEmpty
    }
}

struct EmojiManager {
    
    var emojis = [Emoji]()
    
    init() {
        //获取emoji的路径
//        let path = Bundle.main.path(forResource: "emojis.plist", ofType: nil)
        //根据文件读取数据
//        let arr = NSArray(contentsOfFile: path!) as! [[String: String]]
        //字典转模型
//        emojis = arr.compactMap {
//            Emoji.deserialize(from: $0 as NSDictionary)
//        }
        
        let arrayPath = Bundle.main.path(forResource: "emoji_sort.plist", ofType: nil)
        let sorts = NSArray(contentsOfFile: arrayPath!) as! [String]
        
        let mappingPath = Bundle.main.path(forResource: "emoji_mapping.plist", ofType: nil)
        let mappings = NSDictionary(contentsOfFile: mappingPath!)
        
        var temps = [Emoji]()
        for (index, id) in sorts.enumerated() {
            if index != 0 && index % 20 == 0 {
                temps.append(Emoji(isDelete: true))
            }
            temps.append(Emoji(id: id, png: "emoji_\(id)_32x32_"))
        }
        
        mappings?.enumerateKeysAndObjects({ (key, value, stop) in
            emojis = temps.compactMap({
                var emoji = $0
                if emoji.id == "\(value)" {
                    emoji.name = "\(key)"
                }
                return emoji
            })
        })
        
        //判断分页是否有剩余
        let count = emojis.count % 21
        guard count != 0 else { return }
        for index in count..<21 {
            if index == 20 {
                emojis.append(Emoji(isDelete: true))
            } else {
                emojis.append(Emoji(isEmpty: true))
            }
        }
        
    }
    
    func emojiShow(content: String, font: UIFont) -> NSMutableAttributedString {
        
        let attributed = NSMutableAttributedString(string: content)
        
        //emoji 替换
        let emojiPattern = "\\[.*?\\]" //emoji正则表达式
        let regex = try! NSRegularExpression(pattern: emojiPattern, options: [])
        let results = regex.matches(in: content, options: [], range: NSRange(location: 0, length: attributed.length))
        if results.count != 0 {
            //倒序遍历，避免更改字符串长度
            for index in stride(from: results.count - 1, through: 0, by: -1) {
                //取出结果的范围
                let result = results[index]
                //取出emoji的名字
                let emojiName = (content as NSString).substring(with: result.range)
                let attachment = NSTextAttachment()
                //取出对应的emoji模型
                guard let emoji = emojis.filter({
                    $0.name == emojiName
                }).first else {
                    return attributed
                }
                //设置图片
                attachment.image = UIImage(named: emoji.png)
                attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
                //将图片替换为文字
                let imageString = NSAttributedString(attachment: attachment)
                attributed.replaceCharacters(in: result.range, with: imageString)
            }
        }
        
//        //@用户 替换
//        let userPattern = "@.*?:" //@正则表达式
//        let userRegex = try! NSRegularExpression(pattern: userPattern, options: [])
//        let userResults = userRegex.matches(in: content, options: [], range: NSRange(location: 0, length: attributed.length))
//        if userResults.count != 0 {
//            for result in userResults {
//                let userName = (content as NSString).substring(with: result.range)
//                let attributedName = NSMutableAttributedString(string: userName)
//                attributedName.setAttributes([.foregroundColor: UIColor.blueFontColor()], range: NSRange(location: 0, length: attributedName.length))
//                attributed.replaceCharacters(in: result.range, with: attributedName)
//            }
//        }
        
        return attributed
    }
    
}
