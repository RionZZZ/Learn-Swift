//
//  Const.swift
//  News
//
//  Created by Rion on 2019/2/15.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
let safeAreaBottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom

let BASE_URL = "http://is.snssdk.com"

let device_id = "6096495334"
let iid = "5034850950"

let MineHeaderHeight: CGFloat = 280

let isNight = "isNight"

let isBigPhone: Bool = screenHeight > 800 ? true : false
