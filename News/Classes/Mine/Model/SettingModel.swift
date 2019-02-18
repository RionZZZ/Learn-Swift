//
//  SettingModel.swift
//  News
//
//  Created by Rion on 2019/2/18.
//  Copyright © 2019年 Rion. All rights reserved.
//

import Foundation
import HandyJSON

struct SettingModel: HandyJSON {
    
    var title = ""
    var subtitle = ""
    var rightLabel = ""
    var isHiddenSubtitle = false
    var isHiddenRightLabel = false
    var isHiddenArrow = false
    var isHiddenSwitch = false
}
