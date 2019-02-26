//
//  UserDetailBottomView.swift
//  News
//
//  Created by Rion on 2019/2/20.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

protocol UserDetailBottomDelegate: NSObjectProtocol {
    func bottomView(clicked button: UIButton, bottomTab: BottomTab)
}

class UserDetailBottomView: UIView {
    
    weak var delegate: UserDetailBottomDelegate?
    
    var bottomTabs = [BottomTab]() {
        didSet {
            let buttonWidth: CGFloat = (screenWidth - CGFloat(bottomTabs.count)) / CGFloat(bottomTabs.count)
            for (index, value) in bottomTabs.enumerated() {
                let button = UIButton(frame: CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: height))
                button.setTitle(value.name, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                button.theme_setTitleColor("colors.black", forState: .normal)
                button.theme_setImage("images.tabbar-options", forState: .normal)
                //图文间距
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
                button.tag = index
                button.addTarget(self, action: #selector(bottomTabButtonClick), for: .touchUpInside)
                addSubview(button)
                //分割线
                if index < bottomTabs.count - 1 {
                    let separatorView = UIView(frame: CGRect(x: button.frame.maxX, y: 6, width: 1, height: 32))
                    separatorView.theme_backgroundColor = "colors.separatorColor"
                    addSubview(separatorView)
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func bottomTabButtonClick(button: UIButton) {
        delegate?.bottomView(clicked: button, bottomTab: bottomTabs[button.tag])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        width = screenWidth
    }
}
