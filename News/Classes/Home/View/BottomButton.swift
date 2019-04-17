//
//  BottomButton.swift
//  News
//
//  Created by Rion on 2019/4/17.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class BottomButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 15, y: 9, width: 22, height: 22)
    }

}
