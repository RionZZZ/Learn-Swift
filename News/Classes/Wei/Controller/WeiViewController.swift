//
//  WeiViewController.swift
//  News
//
//  Created by Rion on 2019/3/4.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class WeiViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension WeiViewController {
    
    private func setupUI() {
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        
        ThemeStyle.setNavigationStyle(self, UserDefaults.standard.bool(forKey: isNight))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: UserDefaults.standard.bool(forKey: isNight) ? "follow_title_profile_night_18x18_" : "follow_title_profile_18x18_"), style: .plain, target: self, action: #selector(rightBarClick))
//        if UserDefaults.standard.bool(forKey: isNight) {
//            ThemeStyle.setNightNavigationStyle(self)
//            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "follow_title_profile_night_18x18_"), style: .plain, target: self, action: #selector(rightBarClick))
//        } else {
//            ThemeStyle.setDayNavigationStyle(self)
//            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "follow_title_profile_18x18_"), style: .plain, target: self, action: #selector(rightBarClick))
//        }
        
        //接收更换主题通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightClick), name: NSNotification.Name(rawValue: "dayOrNightClick"), object: nil)
        
    }
    
    @objc func receiveDayOrNightClick(notification: Notification) {
        ThemeStyle.setNavigationStyle(self, notification.object as! Bool)
//        if notification.object as! Bool {
//            ThemeStyle.setNightNavigationStyle(self)
//            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_white_night"), for: .default)
//        } else {
//            ThemeStyle.setDayNavigationStyle(self)
//            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_white"), for: .default)
//        }
    }
    
    @objc func rightBarClick() {
        
    }
}
