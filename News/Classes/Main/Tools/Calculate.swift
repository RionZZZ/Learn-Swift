//
//  Calculate.swift
//  News
//
//  Created by Rion on 2019/2/26.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

protocol Calculatable {
    
    static func collectionViewWidth(_ count: Int) -> CGFloat
    
    static func collectionViewHeight(_ count: Int) -> CGFloat
    
    static func collectionCellSize(_ count: Int) -> CGSize
    
    static func textHeight(text: String, fontSize: CGFloat, width: CGFloat) -> CGFloat
    
    static func textWidth(text: String, fontSize: CGFloat, height: CGFloat) -> CGFloat
    
    static func richContents(from content: String, idPattern: String, titlePattern: String) -> [RichContent]
    
    static func detailCollectionCellSize(_ thumbImageList: [ThumbImage]) -> CGSize
    
    static func detailCollectionViewHeight(_ thumbImageList: [ThumbImage]) -> CGFloat
}

struct Calculate: Calculatable { }

extension Calculate {
    
    static func collectionViewWidth(_ count: Int) -> CGFloat {
        switch count {
//        case 1:
//            return image1Width
        case 1, 2:
            return (image2Width + 5) * 2
        case 3,5...9:
            return screenWidth - 30
        case 4:
            return (image3Width + 5) * 2
        default:
            return 0
        }
    }
    
    static func collectionViewHeight(_ count: Int) -> CGFloat {
        switch count {
//        case 1:
//            return image1Width
        case 1, 2:
            return image2Width
        case 3:
            return image3Width + 5
        case 4...6:
            return (image3Width + 5) * 2
        case 7...9:
            return (image3Width + 5) * 3
        default:
            return 0
        }
    }
    
    static func collectionCellSize(_ count: Int) -> CGSize {
        switch count {
//        case 1:
//            return CGSize(width: image1Width, height: image1Width)
        case 1, 2:
            return CGSize(width: image2Width, height: image2Width)
        case 3...9:
            return CGSize(width: image3Width, height: image3Width)
        default:
            return .zero
        }
    }
    
    static func detailCollectionCellSize(_ thumbImageList: [ThumbImage]) -> CGSize {
        switch thumbImageList.count {
        case 1:
            let thumbImage = thumbImageList.first!
            let height = (screenWidth - 30) + thumbImage.height / thumbImage.width
            return CGSize(width: screenWidth - 30, height: height)
        case 2, 4:
            let image2Width = (screenWidth - 35) / 2
            return CGSize(width: image2Width, height: image2Width)
        case 3, 5...9:
            return CGSize(width: image3Width, height: image3Width)
        default:
            return .zero
        }
    }
    
    static func detailCollectionViewHeight(_ thumbImageList: [ThumbImage]) -> CGFloat {
        switch thumbImageList.count {
        case 1:
            let thumbImage = thumbImageList.first!
            let height = (screenWidth - 30) + thumbImage.height / thumbImage.width
            return height
        case 2:
            return (screenWidth - 35) / 2
        case 3:
            return image3Width + 5
        case 4:
            return screenWidth - 35
        case 5,6:
            return (image3Width + 5) * 2
        case 7...9:
            return (image3Width + 5) * 3
        default:
            return 0
        }
    }
    
    //计算文本宽度
    static func textWidth(text: String, fontSize: CGFloat, height: CGFloat) -> CGFloat {
        return text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes:[.font: UIFont.systemFont(ofSize:fontSize)], context: nil).size.height + 5
    }
    
    //计算文本高度
    static func textHeight(text: String, fontSize: CGFloat, width: CGFloat) -> CGFloat {
        return text.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:[.font: UIFont.systemFont(ofSize:fontSize)], context: nil).size.height + 5
    }
    
    //从文本内容中获取uid和用户名
    static func richContents(from content: String, idPattern: String, titlePattern: String) -> [RichContent] {
        
        var richContents = [RichContent]()
        var temps = [RichContent]()
        
        let idRegex = try! NSRegularExpression(pattern: idPattern, options: [])
        let idResults = idRegex.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
        if idResults.count != 0 {
            temps = idResults.compactMap{
                let id = (content as NSString).substring(with: $0.range)
                return RichContent(id, "")
            }
        }
        
        let titleRegex = try! NSRegularExpression(pattern: titlePattern, options: [])
        let titleResults = titleRegex.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
        if titleResults.count != 0 {
            for (index, value) in titleResults.enumerated() {
                let name = (content as NSString).substring(with: value.range)
                //取出临时数组中的模型
                var richContent = temps[index]
                richContent.name = "@\(name):"
                richContents.append(richContent)
            }
        }
        
        return richContents
    }
    
    
}
