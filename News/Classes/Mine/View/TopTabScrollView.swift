//
//  TopTabScrollView.swift
//  News
//
//  Created by Rion on 2019/4/12.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class TopTabScrollView: UIScrollView {
    
    var previousButton = UIButton()
    lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: (topTabButtonWidth - topTabindicatorWidth) * 0.5, y: height - 2, width: topTabindicatorWidth, height: topTabindicatorHeight))
        indicatorView.theme_backgroundColor = "colors.globalRedColor"
        return indicatorView
    }()
    
    //当前toptab的类型和索引
    var currentTopTabIndex = 0
    var currentTopTab: ((_ topTab: TopTab, _ currentIndex: Int)->())?
    
    var topTabs = [TopTab]() {
        didSet {
            for (index, value) in topTabs.enumerated() {
                let button = UIButton(frame: CGRect(x: CGFloat(index) * topTabButtonWidth, y: 0, width: topTabButtonWidth, height: height))
                button.tag = index
                button.setTitle(value.show_name, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                button.theme_setTitleColor("colors.black", forState: .normal)
                button.theme_setTitleColor("colors.globalRedColor", forState: .selected)
                button.addTarget(self, action: #selector(topTabButtonClick), for: .touchUpInside)
                addSubview(button)
                if index == 0 {
                    button.isSelected = true
                    previousButton = button
                }
                if index == topTabs.count - 1 {
                    contentSize = CGSize(width: button.frame.maxX, height: height)
                }
            }
            addSubview(indicatorView)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        theme_backgroundColor = "colors.cellBackgroundColor"
        
        let bottomBorder = UIView(frame: CGRect(x: 0, y: 39.5, width: screenWidth, height: 0.5))
        bottomBorder.backgroundColor = .lightGray
        addSubview(bottomBorder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func topTabButtonClick(button: UIButton) {
        previousButton.isSelected = false
        button.isSelected = !button.isSelected
        UIView.animate(withDuration: 0.25, animations: {
            self.indicatorView.centerX = button.centerX
        }) { (_) in
            self.previousButton = button
        }
        
        currentTopTabIndex = button.tag
        currentTopTab?(topTabs[button.tag], currentTopTabIndex)
    }
    
}
