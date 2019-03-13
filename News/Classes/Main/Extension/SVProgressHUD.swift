//
//  SVProgressHUD.swift
//  News
//
//  Created by Rion on 2019/3/13.
//  Copyright © 2019年 Rion. All rights reserved.
//

import Foundation
import SVProgressHUD

extension SVProgressHUD {
    
    static func configuration() {
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        SVProgressHUD.setBackgroundColor(UIColor(r: 0, g: 0, b: 0, alpha: 0.3))
    }
}
