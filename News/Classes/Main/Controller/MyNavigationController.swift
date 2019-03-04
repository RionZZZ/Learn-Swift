//
//  MyNavigationController.swift
//  News
//
//  Created by Rion on 2019/2/14.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBar = UINavigationBar.appearance()
//        navigationBar.theme_backgroundColor = "colors.cellBackgroundColor"
        navigationBar.theme_tintColor = "colors.navigationBarTint"
        
        if UserDefaults.standard.bool(forKey: isNight) {
            navigationBar.setBackgroundImage(UIImage(named: "navigation_background_night"), for: .default)
        } else {
            navigationBar.setBackgroundImage(UIImage(named: "navigation_background"), for: .default)
        }
        //接收更换主题通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightClick), name: NSNotification.Name(rawValue: "dayOrNightClick"), object: nil)
        
        //全局手势
        initGlobalPan()
    }
    
    
    @objc func receiveDayOrNightClick(notification: Notification) {
        if notification.object as! Bool {
            navigationBar.setBackgroundImage(UIImage(named: "navigation_background_night"), for: .default)
        } else {
            navigationBar.setBackgroundImage(UIImage(named: "navigation_background"), for: .default)
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "lefterbackicon_titlebar_24x24_"), style: .plain, target: self, action: #selector(navigationBack))
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func navigationBack() {
        popViewController(animated: true)
    }
    
}

extension MyNavigationController: UIGestureRecognizerDelegate {
    //全局拖拽手势
    fileprivate func initGlobalPan() {
        //创建pan手势
        let target = interactivePopGestureRecognizer?.delegate
        let globalPan = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        globalPan.delegate = self
        view.addGestureRecognizer(globalPan)
        //禁止系统手势
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count != 1
    }
}
