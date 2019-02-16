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
    @IBOutlet weak var bottomView: UIView!
    
    class func headerView() -> NoLoginHeaderView {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! NoLoginHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayOrNight.isSelected = UserDefaults.standard.bool(forKey: isNight)
        
        mobileButton.theme_setImage("images.loginMobileButton", forState: .normal)
        wechatButton.theme_setImage("images.loginWechatButton", forState: .normal)
        qqButton.theme_setImage("images.loginQQButton", forState: .normal)
        sinaButton.theme_setImage("images.loginSinaButton", forState: .normal)
        favoriteButton.theme_setImage("images.mineFavoriteButton", forState: .normal)
        historyButton.theme_setImage("images.mineHistoryButton", forState: .normal)
        dayOrNight.theme_setImage("images.dayOrNightButton", forState: .normal)
        dayOrNight.setTitle("夜间", for: .normal)
        dayOrNight.setTitle("日间", for: .selected)
        moreLogin.theme_backgroundColor = "colors.moreLoginBackgroundColor"
        moreLogin.theme_setTitleColor("colors.moreLoginColor", forState: .normal)
        favoriteButton.theme_setTitleColor("colors.black", forState: .normal)
        historyButton.theme_setTitleColor("colors.black", forState: .normal)
        dayOrNight.theme_setTitleColor("colors.black", forState: .normal)
        bottomView.theme_backgroundColor = "colors.cellBackgroundColor"
    }
    
    @IBAction func onDayOrNightClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        UserDefaults.standard.set(sender.isSelected, forKey: isNight)
        Theme.switchNight(sender.isSelected)
        
        //发送通知，全部页面更改主题
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dayOrNightClick"), object: sender.isSelected)
    }
    
}
