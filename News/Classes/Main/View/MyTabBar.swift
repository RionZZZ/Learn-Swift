//
//  MyTabBar.swift
//  News
//
//  Created by Rion on 2019/2/14.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class MyTabBar: UITabBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(publishButton)
    }
    
    private lazy var publishButton : UIButton = {
        let publishButton = UIButton(type: .custom)
        publishButton.setBackgroundImage(UIImage(named: "feed_publish_44x44_"), for: .normal)
        publishButton.setBackgroundImage(UIImage(named: "feed_publish_press_44x44_"), for: .selected)
        publishButton.sizeToFit()
        return publishButton
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = frame.width
        let height = frame.height
        
        publishButton.center = CGPoint(x: width / 2, y: height / 2 - 8)
        
        let buttonWidth : CGFloat = width / 5
        let buttonHeight : CGFloat = height
        let buttonY : CGFloat = 0
        
        var i = 0
        for button in subviews {
            if !button.isKind(of: NSClassFromString("UITabBarButton")!) { continue }
            let buttonX = buttonWidth * CGFloat(i > 1 ? (i + 1) : i)
            button.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
            i += 1
        }
    }
    
}
