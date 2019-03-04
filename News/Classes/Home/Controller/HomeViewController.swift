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
    }

}

extension HomeViewController {

    private func setupUI() {
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        
        navigationController?.navigationBar.barStyle = .black
        navigationItem.titleView = navigationBar
        navigationBar.didSelectedAvatar = { [weak self] in
            self!.navigationController?.pushViewController(MineViewController(), animated: true)
        }
        //        navigationBar.didSelectedSearch = { [weak self] in
        //
        //        }
    }
}
