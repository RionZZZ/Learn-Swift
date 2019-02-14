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
    }
    
    //初始化主控制器
    func setChild(_ childController: UIViewController, title: String, imageName: String, selectedImageName: String) {
        //设置文字图片
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: selectedImageName)
        childController.title = title
        
        let navCtrl = MyNavigationController(rootViewController: childController)
//        navCtrl.navigationItem.title = title
        addChild(navCtrl)
    }
    
    //添加子控制器
    func addChildCtrls() {
        setChild(HomeViewController(), title: "首页", imageName: "home_tabbar_32x32_", selectedImageName: "home_tabbar_press_32x32_")
        setChild(VideoViewController(), title: "视频", imageName: "video_tabbar_32x32_", selectedImageName: "video_tabbar_press_32x32_")
        setChild(HuoshanViewController(), title: "小火山", imageName: "huoshan_tabbar_32x32_", selectedImageName: "huoshan_tabbar_press_32x32_")
        setChild(MainViewController(), title: "我的", imageName: "mine_tabbar_32x32_", selectedImageName: "mine_tabbar_press_32x32_")
        
        //tabBar是readonly属性，通过KVC把属性更改
        setValue(MyTabBar(), forKey: "tabBar")
    }
    

}
