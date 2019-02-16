//
//  MyTabBarController.swift
//  News
//
//  Created by Rion on 2019/2/14.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabber = UITabBar.appearance()
        tabber.tintColor = UIColor(red: 245/255, green: 90/255, blue: 93/255, alpha: 1)
        addChildCtrls()
        
        //接收更换主题通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightClick), name: NSNotification.Name(rawValue: "dayOrNightClick"), object: nil)
    }
    
    @objc func receiveDayOrNightClick(notification: Notification) {
        let isSelected = notification.object as! Bool
        if isSelected {
            //设置为夜间
            for child in children {
                switch child.title! {
                case "首页":
                    setNightChild(controller: child, imageName: "home")
                case "视频":
                    setNightChild(controller: child, imageName: "video")
                case "小火山":
                    setNightChild(controller: child, imageName: "huoshan")
                case "未登陆":
                    setNightChild(controller: child, imageName: "no_login")
                default:
                    break
                }
            }
        } else {
            //设置为日间
            for child in children {
                switch child.title! {
                case "首页":
                    setDayChild(controller: child, imageName: "home")
                case "视频":
                    setDayChild(controller: child, imageName: "video")
                case "小火山":
                    setDayChild(controller: child, imageName: "huoshan")
                case "未登陆":
                    setDayChild(controller: child, imageName: "no_login")
                default:
                    break
                }
            }
        }
    }
    
    //初始化主控制器
    private func setChild(_ childController: UIViewController, title: String, imageName: String) {
        //设置文字图片
//        childController.tabBarItem.image = UIImage(named: imageName)
//        childController.tabBarItem.selectedImage = UIImage(named: selectedImageName)
        if UserDefaults.standard.bool(forKey: isNight) {
            setNightChild(controller: childController, imageName: imageName)
        } else {
            setDayChild(controller: childController, imageName: imageName)
        }
        childController.title = title
        
        let navCtrl = MyNavigationController(rootViewController: childController)
//        navCtrl.navigationItem.title = title
        addChild(navCtrl)
    }
    
    //设置日间控制器
    private func setDayChild(controller: UIViewController, imageName: String){
        controller.tabBarItem.image = UIImage(named: imageName + "_tabbar_32x32_")
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_tabbar_press_32x32_")
    }
    //设置夜间控制器
    private func setNightChild(controller: UIViewController, imageName: String){
        controller.tabBarItem.image = UIImage(named: imageName + "_tabbar_night_32x32_")
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_tabbar_press_night_32x32_")
    }
    
    //添加子控制器
    private func addChildCtrls() {
        setChild(HomeViewController(), title: "首页", imageName: "home")
        setChild(VideoViewController(), title: "视频", imageName: "video")
        setChild(HuoshanViewController(), title: "小火山", imageName: "huoshan")
        setChild(MineViewController(), title: "未登陆", imageName: "no_login")
        
        //tabBar是readonly属性，通过KVC把属性更改
        setValue(MyTabBar(), forKey: "tabBar")
    }
    

}
