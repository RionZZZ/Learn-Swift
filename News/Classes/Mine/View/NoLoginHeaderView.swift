//
//  NoLoginHeaderView.swift
//  News
//
//  Created by Rion on 2019/2/16.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import IBAnimatable

class NoLoginHeaderView: UIView {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var mobileButton: UIButton!
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var qqButton: UIButton!
    @IBOutlet weak var sinaButton: UIButton!
    @IBOutlet weak var moreLogin: AnimatableButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var dayOrNight: UIButton!
    
    class func headerView() -> NoLoginHeaderView {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! NoLoginHeaderView
    }

}
