//
//  HomeViewController.swift
//  News
//
//  Created by Rion on 2019/2/14.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    fileprivate let newsTitleTable = NewsTitleTable()
    
    lazy var navigationBar: HomeNavigationBar = {
        let navigationBar = HomeNavigationBar.loadViewFromNib()
        return navigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Network.loadHomeNewsTitle(completionHandler: { titles in
            //添加数据到数据库中
            self.newsTitleTable.insert(titles)
        })
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        navigationController?.navigationBar.barStyle = .black
        
        if UserDefaults.standard.bool(forKey: isNight) {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_night"), for: .default)
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background"), for: .default)
        }
        
    }

}

extension HomeViewController {

    private func setupUI() {
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        
        navigationItem.titleView = navigationBar
        navigationBar.didSelectedAvatar = { [weak self] in
            self!.navigationController?.pushViewController(MineViewController(), animated: true)
        }
    }
}
