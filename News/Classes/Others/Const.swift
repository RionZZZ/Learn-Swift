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

let isBigPhone: Bool = screenHeight > 800 ? true : false

let BASE_URL = "http://is.snssdk.com"

let device_id = "6096495334"
let iid = "5034850950"

let MineHeaderHeight: CGFloat = 280
let UserDetailHeaderBGHeight: CGFloat = 146

let isNight = "isNight"

/// 关注的用户详情界面 topTab 的按钮的宽度
let topTabButtonWidth: CGFloat = screenWidth / 5
/// 关注的用户详情界面 topTab 的指示条的宽度 和 高度
let topTabindicatorWidth: CGFloat = 40
let topTabindicatorHeight: CGFloat = 2

//广播关闭present
let BottomPresentationControllerDismiss = "BottomPresentationControllerDismiss"

//userDetail一排放几张图片的宽度设置
let image1Width = screenWidth / 2
let image2Width = (screenWidth - 35) / 2
let image3Width = (screenWidth - 40) / 3

let emojiWidth = screenWidth / 7


