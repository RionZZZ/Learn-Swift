//
//  RichLabel.swift
//  News
//
//  Created by Rion on 2019/3/6.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

enum TapRichTextType: Int {
    case none = 0  //没有点击
    case user = 1  //点击@用户
    case link = 2  //点击超链接
    case topic = 3 //点击话题
}

class RichLabel: UILabel {
    
    /// 文本容器，文本可以排版的区域，默认是矩形，可以自定义区域大小
    private lazy var textContainer = NSTextContainer()
    /// 布局管理者，负责对文字进行编辑排版处理，将存储在 NSTextStorage 中的数据转换为可以在视图控件中显示的文本内容
    /// 并把字符编码映射到对应的字形上，然后将字形排版到 NSTextContainer 定义的区域中。
    private lazy var layoutManager = NSLayoutManager()
    /// NSMutableAttributeString 的子类，主要用来存储文本的字符和相关属性
    /// 当 NSTextStorage 中的字符或属性发生改变时，会通知 NSLayoutManager，进而做到文本内容的显示更新。
    private lazy var textStorage = NSTextStorage()
    
    private lazy var userRanges = [NSRange]()
    private lazy var linkRanges = [NSRange]()
    private lazy var topicRanges = [NSRange]()
    
    
    //定义闭包，点击回调
    typealias TapRichText = (String, NSRange ) -> ()
    var userTapeed: TapRichText?
    var topicTapeed: TapRichText?
    var linkTapeed: TapRichText?
    
    private var tapRichTextType: TapRichTextType = .none
    //记录用户点击的range
    var selectedRange = NSRange()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupText()
    }
    
    override var attributedText: NSAttributedString? {
        didSet {
            //将文本设置为可变
            let attributedString = NSMutableAttributedString(attributedString: attributedText!)
            //设置属性
            attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
            //设置textStorage
            textStorage.setAttributedString(attributedString)
            
            userRanges = ranges(from: "@.*?:")
            _ = userRanges.compactMap{
                textStorage.addAttribute(.foregroundColor, value: UIColor.blueFontColor(), range: $0)
            }
            
            topicRanges = ranges(from: "#.*?#")
            _ = topicRanges.compactMap{
                textStorage.addAttribute(.foregroundColor, value: UIColor.blueFontColor(), range: $0)
            }
            
            linkRanges = rangesOfLink()
            _ = linkRanges.compactMap{
                textStorage.addAttribute(.foregroundColor, value: UIColor.blueFontColor(), range: $0)
            }
            
        }
    }
    
    //绘制字形，设置要绘制的范围
    override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.string.count)
        layoutManager.drawGlyphs(forGlyphRange: range, at: .zero)
    }
    
    //处理换行
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = frame.size
    }
    
    
}

extension RichLabel {
    
    private func setupText() {
        // 将 layoutManager 添加到 textStorage 中
        layoutManager.addTextContainer(textContainer)
        // 将 textContainer 添加到 layoutManager 中
        textStorage.addLayoutManager(layoutManager)
        // 设置可以与用户交互
        isUserInteractionEnabled = true
        // 间距
        textContainer.lineFragmentPadding = 0
    }
    
    //返回正则匹配的结果范围
    func ranges(from pattern: String) -> [NSRange] {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        return results(from: regex)
    }
    
    func rangesOfLink() -> [NSRange] {
        //NSDataDetector是NSRegularExpression的子类
        let regex = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        return results(from: regex)
    }
    
    //返回正则的结果
    func results(from regex: NSRegularExpression) -> [NSRange] {
        let results = regex.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.string.count))
        return results.map({ $0.range })
    }
}

extension RichLabel {
    //根据点击的坐标，获取范围
    private func range(of point: CGPoint) -> NSRange {
        
        guard textStorage.length != 0 else { return NSRange() }
        //在textsorage中的索引
        let index = layoutManager.glyphIndex(for: point, in: textContainer)
        
        for range in userRanges {
            if index > range.location && index < range.location + range.length {
                tapRichTextType = .user
                return range
            }
        }
        for range in topicRanges {
            if index > range.location && index < range.location + range.length {
                tapRichTextType = .topic
                return range
            }
        }
        for range in linkRanges {
            if index > range.location && index < range.location + range.length {
                tapRichTextType = .link
                return range
            }
        }
        return NSRange()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取点击的范围
        let point = touches.first!.location(in: self)
        selectedRange = range(of: point)
        //获取点击范围的内容
        let content = (textStorage.string as NSString).substring(with: selectedRange)
        //判断点击的类型
        switch tapRichTextType {
        case .user:
            userTapeed?(content, selectedRange)
        case .link:
            linkTapeed?(content, selectedRange)
        case .topic:
            topicTapeed?(content, selectedRange)
        default:
            break
        }
    }
}
