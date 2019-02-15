//
//  UIColor.swift
//  News
//
//  Created by Rion on 2019/2/15.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat , b: CGFloat, alpha: CGFloat = 1) {
        self.init(displayP3Red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
    }
    
    class func globalBgc() -> UIColor {
        return UIColor(r: 247, g: 248, b: 249)
    }
    
}

