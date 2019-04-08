//
//  DongtaiDetailController.swift
//  News
//
//  Created by Rion on 2019/3/13.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class DongtaiDetailController: UITableViewController {
    
    var dongtai = UserDetailDongtai() {
        didSet {
            
        }
    }

    lazy var navigationBar: DongtaiNavigationView = {
        let navView = DongtaiNavigationView.loadViewFromNib()
        return navView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
}

extension DongtaiDetailController {
    
    func setupUI() {
        
        tableView.theme_backgroundColor = "colors.cellBackgroundColor"
        navigationItem.titleView = navigationBar
    
        ThemeStyle.setNavigationStyle(self, UserDefaults.standard.bool(forKey: isNight))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: UserDefaults.standard.bool(forKey: isNight) ? "follow_title_profile_night_18x18_" : "follow_title_profile_18x18_"), style: .plain, target: self, action: #selector(rightBarClick))
        
        //接收更换主题通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightClick), name: NSNotification.Name(rawValue: "dayOrNightClick"), object: nil)
        
    }
    
    @objc func receiveDayOrNightClick(notification: Notification) {
        ThemeStyle.setNavigationStyle(self, notification.object as! Bool)
    }
    
    @objc func rightBarClick() {
        
    }
}
