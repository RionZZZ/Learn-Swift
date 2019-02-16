//
//  UIView.swift
//  News
//
//  Created by Rion on 2019/2/16.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

protocol RegisterCellOrNib {}

extension RegisterCellOrNib {
    
    static var identifier : String {
        return "\(self)"
    }
    
    static var nib : UINib? {
        return UINib(nibName: "\(self)", bundle: nil)
    }
}
