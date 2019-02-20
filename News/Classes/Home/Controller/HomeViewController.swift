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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Network.loadHomeNewsTitle(completionHandler: { titles in
            //添加数据到数据库中
            self.newsTitleTable.insert(titles)
        })
    }

}
