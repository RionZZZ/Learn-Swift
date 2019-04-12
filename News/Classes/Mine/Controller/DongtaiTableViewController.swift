//
//  DongtaiTableViewController.swift
//  News
//
//  Created by Rion on 2019/4/11.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class DongtaiTableViewController: UITableViewController {
    
    //当前topTab类型
    var currentTopTab: TopTabType = .dongtai
    var userId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
