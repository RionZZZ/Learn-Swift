//
//  Int.swift
//  News
//
//  Created by Rion on 2019/3/4.
//  Copyright © 2019年 Rion. All rights reserved.
//

import Foundation

extension Int {
    func convertString() -> String {
        guard self >= 10000 else {
            return String(describing: self)
        }
        return String(format: "%.1f万", Float(self) / 10000)
    }
}


