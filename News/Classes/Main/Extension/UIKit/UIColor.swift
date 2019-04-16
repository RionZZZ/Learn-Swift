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
    
    class func grayColor113() -> UIColor {
        return UIColor(r: 113, g: 113, b: 113)
    }
    
    class func blueFontColor() -> UIColor {
        return UIColor(r: 76, g: 105, b: 44)
    }
    
    class func grayColor210() -> UIColor {
        return UIColor(r: 210, g: 210, b: 210)
    }
    
}

